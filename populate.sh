cat datas/DAOs.csv | psql -U pc2973 -d pc2973_db -c "COPY DAOs from STDIN CSV HEADER"
cat datas/Developers.csv | psql -U pc2973 -d pc2973_db -c "COPY Developers from STDIN CSV HEADER"
cat datas/Hackers.csv | psql -U pc2973 -d pc2973_db -c "COPY Hackers from STDIN CSV HEADER"
cat datas/Auditors.csv | psql -U pc2973 -d pc2973_db -c "COPY Auditors from STDIN CSV HEADER"
cat datas/Chains.csv | psql -U pc2973 -d pc2973_db -c "COPY Chains from STDIN CSV HEADER"
cat datas/DEFIProtocols.csv | psql -U pc2973 -d pc2973_db -c "COPY DEFIProtocols from STDIN CSV HEADER"
cat datas/GovernanaceTokens.csv | psql -U pc2973 -d pc2973_db -c "COPY GovernanaceTokens from STDIN CSV HEADER"
cat datas/HackedEvents.csv | psql -U pc2973 -d pc2973_db -c "COPY HackedEvents from STDIN CSV HEADER"
cat datas/involve.csv | psql -U pc2973 -d pc2973_db -c "COPY involve from STDIN CSV HEADER"
cat datas/audited_by.csv | psql -U pc2973 -d pc2973_db -c "COPY audited_by from STDIN CSV HEADER"
cat datas/deployed_on.csv | psql -U pc2973 -d pc2973_db -c "COPY deployed_on from STDIN CSV HEADER"
cat datas/work_in.csv | psql -U pc2973 -d pc2973_db -c "COPY work_in from STDIN CSV HEADER"
