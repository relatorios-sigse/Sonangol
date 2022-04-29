SELECT
/** 
Criação:  
01-07-2020. Andrés Del Río. Mostra os mapeamentos de requisitos legais do menú de consulta REQ039 no SE Suite.
Além disso, foram incluídos os atributos do requisito "Id Requisito", "Data de emisão", "Departamento" e "Palavra chave".

Ambiente: https://sii.sonangol.co.ao/se
Versão: 2.1.5.131 (versão atual - no temos a versão real quando foi criada)
Painel de análise: SNLEP.DQSA.RL - Mapeamento de Requisitos Legais - DQSA
        
Alterações: 
DD-MM-AAAA. Autor. Descripção.    
**/

        RQMAPREV.CDMAPPING,
        RQMAPREV.CDREVISION,
        GGTR.CDGENTYPE,
        (SELECT
            COUNT(1) 
        FROM
            RQREQUIREMENT 
        WHERE
            RQREQUIREMENT.CDREQUIREMENTOWNER=RQREQ.CDREQUIREMENT 
            AND RQREQUIREMENT.CDREQUIREMENT <> RQREQUIREMENT.CDREQUIREMENTOWNER 
            AND RQREQUIREMENT.CDREVISION=RQREQ.CDREVISION) AS FGSINGLE,
        RQREQ.CDREQUIREMENT,
        RQREQ.CDREVISION AS CDREQUIREMENTREV,
        RQMAPCFG.CDEVALMAP,
        RQMAPCFG.FGOBJECTMAP,
        RQMAPREV.FGREVSTATUS,
        RQMAPREV.IDMAPPING,
        RQMAPREV.NMMAPPING,
        GNR.IDREVISION,
        RQREQ.IDREQUIREMENT,
        RQREQ.NMREQUIREMENT,
        1 AS HAS_MAPPING,
        RQC.QTAPPLYTOTAL,
        RQC.QTAPPLY,
        RQC.VLIMPLEMENTED,
        RQC.CDEVALRESULTUSED,
        GNERU.VLEVALRESULT,
        GNER.NMEVALRESULT,
        GNER.IDCOLOR,
        GNER.FGSYMBOL,
        ADBU.CDDEPARTMENT,
        ADBU.IDDEPARTMENT,
        ADBU.NMDEPARTMENT,
        MAP_AREA.QTD_AREA AS ASSOC_AREA,
        GGTR.IDGENTYPE,
        (CASE 
            WHEN MAP_AREA.QTD_AREA > 1 THEN CAST(MAP_AREA.QTD_AREA AS VARCHAR(255)) + ' ' + '#{102519}' 
            WHEN MAP_AREA.QTD_AREA=1 THEN (SELECT
                ADAREA.IDDEPARTMENT + ' - ' + ADAREA.NMDEPARTMENT AS AREA_NAME 
            FROM
                ADDEPARTMENT ADAREA 
            INNER JOIN
                RQMAPPINGDEPT RQDEPT 
                    ON ADAREA.CDDEPARTMENT=RQDEPT.CDDEPARTMENT 
            WHERE
                MAP_AREA.CDMAPPING=RQDEPT.CDMAPPING 
                AND MAP_AREA.CDMAPPINGREVISION=RQDEPT.CDMAPPINGREVISION) 
            ELSE '' 
        END) AS QTD_AREA,
        GGTR.IDGENTYPE + ' - ' + GGTR.NMGENTYPE AS IDNM_GENTYPE,
        ADBU.IDDEPARTMENT + ' - ' + ADBU.NMDEPARTMENT AS BUSINESSUNIT ,
		
		
		(SELECT GNASSOCATTRIB.NMVALUE FROM GNASSOCATTRIB LEFT OUTER JOIN ADATTRIBUTE ON GNASSOCATTRIB.CDATTRIBUTE = ADATTRIBUTE.CDATTRIBUTE WHERE GNASSOCATTRIB.CDASSOC = RQREQ.CDASSOC AND ADATTRIBUTE.CDATTRIBUTE = 446) AS ID_REQ,
		
		(SELECT GNASSOCATTRIB.DTVALUE FROM GNASSOCATTRIB LEFT OUTER JOIN ADATTRIBUTE ON GNASSOCATTRIB.CDATTRIBUTE = ADATTRIBUTE.CDATTRIBUTE WHERE GNASSOCATTRIB.CDASSOC = RQREQ.CDASSOC AND ADATTRIBUTE.CDATTRIBUTE = 447) AS DATA_EMISSAO_REQ,
		
		(SELECT ADATTRIBVALUE.NMATTRIBUTE
    	FROM GNASSOCATTRIB 
    	     LEFT OUTER JOIN ADATTRIBUTE ON GNASSOCATTRIB.CDATTRIBUTE = ADATTRIBUTE.CDATTRIBUTE
    	     LEFT OUTER JOIN ADATTRIBVALUE ON ADATTRIBVALUE.CDATTRIBUTE= GNASSOCATTRIB.CDATTRIBUTE AND ADATTRIBVALUE.CDVALUE  = GNASSOCATTRIB.CDVALUE
     WHERE GNASSOCATTRIB.CDASSOC = RQREQ.CDASSOC AND ADATTRIBUTE.CDATTRIBUTE = 448) AS DEPARTAMENTO_REQ,
	 
	 (SELECT ADATTRIBVALUE.NMATTRIBUTE
    	FROM GNASSOCATTRIB 
    	     LEFT OUTER JOIN ADATTRIBUTE ON GNASSOCATTRIB.CDATTRIBUTE = ADATTRIBUTE.CDATTRIBUTE
    	     LEFT OUTER JOIN ADATTRIBVALUE ON ADATTRIBVALUE.CDATTRIBUTE= GNASSOCATTRIB.CDATTRIBUTE AND ADATTRIBVALUE.CDVALUE  = GNASSOCATTRIB.CDVALUE
     WHERE GNASSOCATTRIB.CDASSOC = RQREQ.CDASSOC AND ADATTRIBUTE.CDATTRIBUTE = 449) AS PALAVRA_CHAVE_REQ
		
		
    FROM
        RQMAPPINGREVISION RQMAPREV 
    INNER JOIN
        GNREVISION GNR 
            ON GNR.CDREVISION=RQMAPREV.CDREVISION 
    INNER JOIN
        RQMAPPINGCONFIG RQMAPCFG 
            ON RQMAPCFG.CDGENTYPE=RQMAPREV.CDGENTYPE 
    INNER JOIN
        GNGENTYPE GGTM 
            ON GGTM.CDGENTYPE=RQMAPCFG.CDGENTYPE 
    INNER JOIN
        RQTYPE RQT 
            ON RQT.CDGENTYPE=RQMAPCFG.CDREQTYPE 
    INNER JOIN
        GNGENTYPE GGTR 
            ON GGTR.CDGENTYPE=RQT.CDGENTYPE 
    INNER JOIN
        RQMAPPINGREQM RQMR 
            ON RQMR.CDMAPPING=RQMAPREV.CDMAPPING 
            AND RQMR.CDMAPPINGREVISION=RQMAPREV.CDREVISION 
    INNER JOIN
        RQREQUIREMENT RQREQ 
            ON RQREQ.CDREQUIREMENT=RQMR.CDREQUIREMENT 
            AND RQREQ.CDREVISION=RQMR.CDREQUIREMENTREV 
    INNER JOIN
        RQREVISION RQREV 
            ON RQREQ.CDREQUIREMENT=RQREV.CDREQUIREMENT 
            AND RQREQ.CDREVISION=RQREV.CDREVISION 
    INNER JOIN
        GNREVCONFIG GNRC 
            ON GNRC.CDREVCONFIG=GGTM.CDREVCONFIG 
    INNER JOIN
        RQMAPCOVERAGE RQC 
            ON RQC.CDREQUIREMENT=RQMR.CDREQUIREMENT 
            AND RQC.CDREQUIREMENTREV=RQMR.CDREQUIREMENTREV 
            AND RQC.CDMAPPING=RQMR.CDMAPPING 
            AND RQC.CDMAPPINGREVISION=RQMR.CDMAPPINGREVISION 
    INNER JOIN
        ADDEPARTMENT ADBU 
            ON RQMAPREV.CDBUSINESSUNIT=ADBU.CDDEPARTMENT 
    LEFT OUTER JOIN
        GNEVALRESULTUSED GNERU 
            ON GNERU.CDEVALRESULTUSED=RQC.CDEVALRESULTUSED 
    LEFT OUTER JOIN
        GNEVALRESULT GNER 
            ON GNERU.CDEVALRESULT=GNER.CDEVALRESULT 
    LEFT OUTER JOIN
        (
            SELECT
                CDMAPPING,
                CDMAPPINGREVISION,
                COUNT(1) AS QTD_AREA 
            FROM
                RQMAPPINGDEPT 
            GROUP BY
                CDMAPPING,
                CDMAPPINGREVISION
        ) MAP_AREA 
            ON MAP_AREA.CDMAPPING=RQMAPREV.CDMAPPING 
            AND MAP_AREA.CDMAPPINGREVISION=RQMAPREV.CDREVISION 
    WHERE
        RQMAPREV.FGCURRENT=1 
        AND GNR.FGSTATUS=6 
        AND (
            RQT.CDTYPEROLE IS NULL 
            OR EXISTS (
                SELECT
                    NULL 
                FROM
                    (SELECT
                        CHKUSRPERMTYPEROLE.CDTYPEROLE AS CDTYPEROLE,
                        CHKUSRPERMTYPEROLE.CDUSER 
                    FROM
                        (SELECT
                            PM.FGPERMISSIONTYPE,
                            PM.CDUSER,
                            PM.CDTYPEROLE 
                        FROM
                            GNUSERPERMTYPEROLE PM 
                        WHERE
                            1=1 
                            AND PM.CDUSER <> -1 
                            AND PM.CDPERMISSION=5 /* Nao retirar este comentario */
                        UNION
                        ALL SELECT
                            PM.FGPERMISSIONTYPE,
                            US.CDUSER AS CDUSER,
                            PM.CDTYPEROLE 
                        FROM
                            GNUSERPERMTYPEROLE PM CROSS 
                        JOIN
                            ADUSER US 
                        WHERE
                            1=1 
                            AND PM.CDUSER=-1 
                            AND US.FGUSERENABLED=1 
                            AND PM.CDPERMISSION=5
                    ) CHKUSRPERMTYPEROLE 
                GROUP BY
                    CHKUSRPERMTYPEROLE.CDTYPEROLE,
                    CHKUSRPERMTYPEROLE.CDUSER 
                HAVING
                    MAX(CHKUSRPERMTYPEROLE.FGPERMISSIONTYPE)=1) CHKPERMTYPEROLE 
            WHERE
                CHKPERMTYPEROLE.CDTYPEROLE=RQT.CDTYPEROLE 
                AND (
                    CHKPERMTYPEROLE.CDUSER=3485 
                    OR 3485=-1
                )
            ))