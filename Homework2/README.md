
# Ödev 2

## SORT işlemi
JSORT001.jcl Dosyasında bir liste oluşturuldu ve JCL sort özelliği kullanılarak sıralandı. Sıralanan liste UserID.QSAM.BB isimli bir dosyaya çıktı alındı.

JCL Dosyasında aynı zamanda Veri Seti silmek için IDCAMS özelliği kullanılmıştır.

```
//DELET100 EXEC PGM=IDCAMS 
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
   DELETE &SYSUID..QSAM.AA NONVSAM
   IF LASTCC LE 08 THEN SET MAXCC = 00 
```
kod bloğu ile QSAM.AA dosyası silinmiştir dosyanın var olmaması durumunda hata vereceğinden dolayı MAXCC 0'a eşitlenmiştir.

```
//SORT0200 EXEC PGM=SORT
//SYSOUT   DD SYSOUT=*
//SORTIN   DD *
0003RAMAZAN BURAK  DEYIRMENCI     19991214
0001MEHMET         DEYIRMENCI     19621010
0002MÜZEYYEN       DEYIRMENCI     19621010
//SORTOUT  DD DSN=&SYSUID..QSAM.AA,
//             DISP=(NEW,CATLG,DELETE), 
//             SPACE=(TRK,(5,5),RLSE), 
//             DCB=(RECFM=FB,LRECL=42)
```
SORTIN komutu ile liste belirlenmiştir,
SORTOUT komutu ile Sıralanmış Listenin nereye çıkacağı belirlenmiştir.
```
    SORT FIELDS=(1,4,CH,A)
    INCLUDE COND=(1,1,CH,EQ,C'0') 
    OUTREC FIELDS=(1,42,DATE1)
```
SORT FIELDS ifadesi sıralama koşulunu belirlemek için kullanılmıştır,
INCLUDE COND hangi koşulu sağlayan elemanların listeye gireceğini belirlemek için kullanılmıştır,
OUTREC FIELDS ifadesi 1'den 42. karaktere kadar olan kısmın yazılmasını ve DATE1 ifadesi ile sistem tarihinin çıktı dosyasına ekelenmesini sağlamıştır.

## Gün Sayısı Hesaplama

DAYCALC1.CBL Dosyasında ..QSAM.BB dosyasındaki sıralanmış verileri okuyarak doğum tarihinden veri giriş tarihine kadar geçen gün sayısı hesaplanmıştır.

```
ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT PRINT-LINE ASSIGN TO PRTLINE.
                      STATUS ST-PRINT-LINE. 
    SELECT DATE-REC   ASSIGN TO DATEREC
                      STATUS ST-DATE-REC. 
```
Giriş ve çıkıç dosyalarının tanımlamaları yapılmıştır, STATUS özelliği ile dosyanın kontrolleri sağlanacaktır.

```
OPEN INPUT  DATE-REC.
OPEN OUTPUT PRINT-LINE.
IF (ST-DATE-REC NOT = 0) AND (ST-DATE-REC NOT = 97)
DISPLAY 'UNABLE TO OPEN INPFILE: ' ST-DATE-REC 
MOVE ST-DATE-REC TO RETURN-CODE
PERFORM H999-PROGRAM-EXIT
END-IF.
```
dosyalar açılmış ve açılma sırasında bir hata olup olmadığı kontrol edilmiştir.

```
H200-READ-NEXT-RECORD.
    PERFORM CALC-RECORD
    READ DATE-REC.
H200-END. EXIT.
```
fonksiyonu ile DATE dosyası okunmaya devam edilmiş ve her seferinde gerekli işlem fonksiyonu çağırılmıştır.

