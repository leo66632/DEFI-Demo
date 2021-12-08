SELECT name
FROM DEFIProtocols;

-- input variable: pName
SELECT DP.name, SUM(HE.valueLost) valueLost, AB.auditors, STRING_AGG(DISTINCT D_O.chain, ', ') chains, GT.tokens, DP.DAO
FROM (SELECT DP.name DEFIProtocol, STRING_AGG(DISTINCT AB.auditor, ', ') auditors
      FROM DEFIProtocols DP LEFT OUTER JOIN audited_by AB
      ON DP.name = AB.DEFIProtocol
      GROUP BY DP.name) AS AB,
      (SELECT DP.name DEFIProtocol, STRING_AGG(DISTINCT GT.name, ', ') tokens
      FROM DEFIProtocols DP LEFT OUTER JOIN GovernanaceTokens GT
      ON DP.DAO = GT.DAO
      GROUP BY DP.name) AS GT,
      DEFIProtocols DP, deployed_on D_O, HackedEvents HE
WHERE DP.name = GT.DEFIProtocol
AND DP.name = D_O.DEFIProtocol
AND DP.name = AB.DEFIProtocol
AND DP.name = HE.DEFIProtocol
GROUP BY DP.name, AB.auditors, GT.tokens;

-- input:
SELECT DP.name, DP.totalValueLocked, SUM(HE.valueLost), COUNT(*)
FROM DEFIProtocols DP, HackedEvents HE
WHERE DP.name = HE.DEFIProtocol
GROUP BY DP.name, DP.totalValueLocked;
-- SORT BY XXX

SELECT A.name, STRING_AGG(DISTINCT AB.DEFIProtocol, ', '), COUNT(*), A.foundYear
FROM Auditors A, audited_by AB
WHERE A.name = AB.auditor
GROUP BY A.name, A.foundYear;

SELECT AB.auditor, Count(DISTINCT AB.DEFIProtocol), COUNT(*), SUM(HE.valueLost)
FROM (SELECT auditor, DEFIProtocol, MIN(auditTime) auditTime
      FROM audited_by
      GROUP BY auditor, DEFIProtocol) AS AB, HackedEvents HE
WHERE HE.DEFIProtocol = AB.DEFIProtocol
AND HE.hackedTime >= AB.auditTime
GROUP BY AB.auditor;

SELECT C.name, C.nativeToken, C.chainId, C.organization, Count(*), STRING_AGG(D_O.DEFIProtocol, ', ') protocols
FROM Chains C, deployed_on D_O
WHERE C.name = D_O.chain
GROUP BY C.name, C.nativeToken, C.chainId, C.organization;

SELECT C.name, COUNT(*), SUM(HE.valueLost)
FROM Chains C, HackedEvents HE
WHERE C.name = HE.chain
GROUP BY C.name;
