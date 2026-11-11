/* 1. Connect to CAS using the configured default server */
cas mySession;

/* 2. Assign available CASlibs as SAS librefs */
caslib _all_ assign;

/* 3. Check available CASlibs */
caslib _all_ list;

/* 4 terminate CAS session */
* cas mySession terminate;
