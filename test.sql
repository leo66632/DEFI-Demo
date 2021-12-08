SELECT C.name, COUNT(*), SUM(HE.valueLost)
FROM Chains C, HackedEvents HE
WHERE C.name = HE.chain
GROUP BY C.name;
