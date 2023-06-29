
# Ödev 3

FILTER01.CBL dosyası ile VSAM Dosyası okuma ve filreleme işlemi gerçekleştirilmiştir.

```
ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT IDX-FILE  ASSIGN TO IDXFILE
                     ORGANIZATION INDEXED
                     ACCESS RANDOM
                     RECORD KEY IDX-KEY
                     STATUS ST-IDX.
    SELECT OUT-FILE  ASSIGN TO OUTFILE
                     STATUS ST-OUT.
    SELECT INP-FILE  ASSIGN TO INPFILE
                     STATUS ST-INP.
```
normal dosya okumadan farklı olarak VSAM Dosyası okuma işleminde RECORD KEY özelliği, ACCESS özelliği, ve ORGANIZATION Özelliği Kullanılmıştır. \
ORGANIZATION INDEXED ifadesi, anahtar alanlarına dayalı olarak kayıtlara erişim sağlayan veri yapısı olduğunu belirtir \
ACCESS RANDOM ifadesi, dosyaya rastgele (random) erişimin yapılabileceğini belirtir.\
RECORD KEY IDX-KEY ifadesi, dosyadaki kayıtların erişiminde kullanılacak olan anahtar alanını belirtir. IDX-KEY, dosyanın kayıtlarını benzersiz bir şekilde tanımlayan bir alanın adını temsil eder. Bu alan, dosyadaki kayıtların sıralanması ve erişimi için kullanılır.

```
FD  IDX-FILE.
    01  IDX-REX.
      03 IDX-KEY.
         05 IDX-ID         PIC S9(5) COMP-3.
         05 IDX-DVZ        PIC S9(3) COMP.
      03 IDX-NAME          PIC X(30).
      03 IDX-DATE          PIC S9(07) COMP-3.
      03 IDX-BALANCE       PIC S9(15) COMP-3.
```
VSAM dosyası okunurken RECORDING MODE ifadesi kullanılmasına gerek yoktur,
Verilere ulaşmak için kullanılacak olan IDX-KEY, IDX-ID ve IDX-DVZ şeklinde iki farklı değişkenden oluşmaktadır.
```
COMPUTE IDX-ID = FUNCTION NUMVAL-C (REC-ID)
COMPUTE IDX-DVZ = FUNCTION NUMVAL (REC-DVZ)
READ IDX-FILE KEY IDX-KEY
  INVALID KEY PERFORM WRNG-RECORD
  NOT INVALID KEY PERFORM WRITE-RECORD.
```
VSAM Dosayasından veri okumak için key içeriğindeki veriler farklı bir dosyadan okunan veriler ile dolduruluyor ve `KEY` özelliği kullanılarak veriler okunuyor, belirtilen key ile veri bulunabilir ise WRITE-RECORD fonksiyonu, bulunamaz ise WRNG-RECORD fonksiyonu çalıştırılıyor.