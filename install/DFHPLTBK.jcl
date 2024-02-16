* Licensed Materials - Property of IBM
*
* (c) Copyright IBM Corp. 2015,2016.
*
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract
* with IBM Corp.

         TITLE 'PLT (BK) FOR HURSLEY BANK'
         DFHPLT TYPE=INITIAL,SUFFIX=BK
*
         DFHPLT TYPE=ENTRY,PROGRAM=DFHDELIM
*
         DFHPLT TYPE=ENTRY,PROGRAM=STVAT
*
         DFHPLT TYPE=ENTRY,PROGRAM=ESDSEXIT
*
         DFHPLT TYPE=FINAL
         END
