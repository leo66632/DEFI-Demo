import pandas as pd
import psycopg2
import streamlit as st
from configparser import ConfigParser

"# Demo: Streamlit + Postgres"


@st.cache
def get_config(filename="database.ini", section="postgresql"):
    parser = ConfigParser()
    parser.read(filename)
    return {k: v for k, v in parser.items(section)}


@st.cache
def query_db(sql: str):
    # print(f"Running query_db(): {sql}")
    db_info = get_config()
    # Connect to an existing database
    conn = psycopg2.connect(**db_info)
    # Open a cursor to perform database operations
    cur = conn.cursor()
    # Execute a command: this creates a new table
    cur.execute(sql)
    # Obtain data
    data = cur.fetchall()
    column_names = [desc[0] for desc in cur.description]
    # Make the changes to the database persistent
    conn.commit()
    # Close communication with the database
    cur.close()
    conn.close()
    df = pd.DataFrame(data=data, columns=column_names)
    return df

"## Query a Protocol"

sql_protocol_names = "SELECT name FROM DEFIProtocols;"
try:
    protocol_names = query_db(sql_protocol_names)["name"].tolist()
    protocol_name = st.selectbox("Choose a protocol", protocol_names)
except:
    st.write("Sorry! Something went wrong with your query, please try again.")

if protocol_name:
    sql_protocol = f"""SELECT DP.name, SUM(HE.valueLost) valueLost, AB.auditors auditors, STRING_AGG(DISTINCT D_O.chain, ', ') chains, GT.tokens tokens, DP.DAO DAO
    FROM (SELECT DP.name DEFIProtocol, STRING_AGG(DISTINCT AB.auditor, ', ') auditors
        FROM DEFIProtocols DP LEFT OUTER JOIN audited_by AB
        ON DP.name = AB.DEFIProtocol
        GROUP BY DP.name) AS AB,
        (SELECT DP.name DEFIProtocol, STRING_AGG(DISTINCT GT.name, ', ') tokens
        FROM DEFIProtocols DP LEFT OUTER JOIN GovernanaceTokens GT
        ON DP.DAO = GT.DAO
        GROUP BY DP.name) AS GT,
        DEFIProtocols DP, deployed_on D_O, HackedEvents HE
    WHERE DP.name = '{protocol_name}'
    AND DP.name = GT.DEFIProtocol
    AND DP.name = D_O.DEFIProtocol
    AND DP.name = AB.DEFIProtocol
    AND DP.name = HE.DEFIProtocol
    GROUP BY DP.name, AB.auditors, GT.tokens;"""
    try:
        protocol_info = query_db(sql_protocol).loc[0]
        protocol_name, p_valueLost, p_auditors, p_chains, p_tokens,p_Daos = (
            protocol_info["name"],
            protocol_info["valuelost"],
            protocol_info["auditors"],
            protocol_info["chains"],
            protocol_info["tokens"],
            protocol_info["dao"],
        )
        st.write(
            f"{protocol_name} is an application depolyed on {p_chains} chain(s), governed by {p_Daos} with {p_tokens} as their governance token."
        )
        st.write(
            f"So far, it has lost {p_valueLost} USD value because of hacker attack(s)."
        )
        st.write(
            f"The protocol's smart contract has been auditted by {p_auditors} "
        )
    except:
        st.write(
            "Sorry! Something went wrong with your query, please try again."
        )



"## List Protocols"

try:
    sorting_opts = ['name', 'total value locked', 'value lost', 'hacked times']
    sorting_opt = st.selectbox("Order by", sorting_opts)
except:
    st.write("Sorry! Something went wrong with your query, please try again.")

if sorting_opt == 'total value locked':
    sorting_opt = 'totalValueLocked'
elif sorting_opt == 'value lost':
    sorting_opt = 'totalValueLost'
elif sorting_opt == 'hacked times':
    sorting_opt = 'hackedTimes'

if sorting_opt:
    sql_protocol_table = f"""
        SELECT DP.name, DP.totalValueLocked, SUM(HE.valueLost) totalValueLost, COUNT(*) hackedTimes
        FROM DEFIProtocols DP, HackedEvents HE
        WHERE DP.name = HE.DEFIProtocol
        GROUP BY DP.name, DP.totalValueLocked
        ORDER BY {sorting_opt};"""

    try:
        protocol_table = query_db(sql_protocol_table)
        st.dataframe(protocol_table)
    except:
        st.write(
            "Sorry! Something went wrong with your query, please try again."
        )


"## Query an Auditor"

sql_auditor_names = "SELECT name FROM Auditors;"
try:
    auditor_names = query_db(sql_auditor_names)["name"].tolist()
    auditor_name = st.selectbox("Choose an auditor", auditor_names)
except:
    st.write("Sorry! Something went wrong with your query, please try again.")

if auditor_name:
    sql_auditor = f"""SELECT A.name, STRING_AGG(DISTINCT AB.DEFIProtocol, ', ') protocols, COUNT(*) audits, A.foundYear
    FROM Auditors A, audited_by AB
    WHERE A.name = '{auditor_name}'
    AND A.name = AB.auditor
    GROUP BY A.name, A.foundYear;
    """
    try:
        auditor_info = query_db(sql_auditor).loc[0]
        auditor_name, a_protocols, a_audits, a_foundYear = (
            auditor_info["name"],
            auditor_info["protocols"],
            auditor_info["audits"],
            auditor_info["foundyear"],
        )
        st.write(
            f"""{auditor_name} is found in {a_foundYear}, it has {a_audits} audit records in our database.
            The audited protocols are as follows: {a_protocols} """
        )
    except:
        st.write(
            "Sorry! Something went wrong with your query, please try again."
        )
