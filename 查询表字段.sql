SELECT 表名      =CASE WHEN a.colorder=1 THEN d.name ELSE '' END
                              ,表说明    =CASE WHEN a.colorder=1 THEN ISNULL(f.value,'') ELSE '' END
                              ,字段序号   =a.colorder
                              ,字段名    =a.name
                              ,标识     =CASE WHEN COLUMNPROPERTY( a.id,a.name,'IsIdentity')=1 THEN '√'ELSE '' END
                              ,主键     =CASE WHEN EXISTS(SELECT 1 FROM sysobjects WHERE xtype='PK' AND name IN (
                                            SELECT name FROM sysindexes WHERE indid IN(
                                                SELECT indid FROM sysindexkeys WHERE id = a.id AND colid=a.colid
                                        ))) THEN '√' ELSE '' END
                              ,类型     =b.name
                              ,占用字节   =a.length
                              ,长度     =COLUMNPROPERTY(a.id,a.name,'PRECISION')
                              ,小数位数   =ISNULL(COLUMNPROPERTY(a.id,a.name,'Scale'),0)
                              ,允许空    =CASE WHEN a.isnullable=1 THEN '1'ELSE '' END
                              ,默认值    =ISNULL(e.text,'')
                              ,字段说明   =ISNULL(g.[value],'')
                          FROM syscolumns a
                          LEFT JOIN systypes b ON a.xusertype=b.xusertype
                         INNER JOIN sysobjects d ON a.id=d.id AND d.xtype='U' AND d.name<>'dtproperties'
                          LEFT JOIN syscomments e ON a.cdefault=e.id
                          LEFT JOIN sys.extended_properties g ON a.id=g.major_id AND a.colid=g.minor_id
                          LEFT JOIN sys.extended_properties f ON d.id=f.major_id AND f.minor_id=0
                         WHERE d.name='FunctionAll_Group' ORDER BY a.id,a.colorder