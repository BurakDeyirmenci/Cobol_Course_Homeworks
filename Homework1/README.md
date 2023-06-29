
# Ödev 1

Hatalı olan JCL Dosyası düzenlendi ve ayrı bir data dosyası oluşturalacak şekilde ayarlandı

JCL osyasında bulunan PRTLINE parametresini aşağıdaki şekilde değiştirilerek yeni dosya oluşturulması sağlandı

```
//PRTLINE   DD DSN=&SYSUID..DATA.PTR,
//             DISP=(NEW,CATLG,DELETE),
//             UNIT=SYSDA,
//             SPACE=(TRK,(10,10),RLSE),
//             DCB=(RECFM=FB,LRECL=150,BLKSIZE=0)
```

DISP=(NEW,CATLG,DELETE) ifadesi, veri kümesinin yeni oluşturulmasını ve eğer oluşturulabilirse kataloglanmasını ve oluşturulamazsa silinmesini sağlar.

UNIT=SYSDA ifadesi ise veri kümesinin SYSDA cihazında yer alacağını belirtir.

SPACE=(TRK,(10,10),RLSE) ifadesi, veri kümesi için tahsis edilecek alanın boyutunu belirtir. Burada, 10 iz üzerinden 10 izlik bir alan tahsis edildiği belirtilmektedir. RLSE, veri kümesi kullanılmadığında bu alanın serbest bırakılacağını ifade eder.

DCB=(RECFM=FB,LRECL=150,BLKSIZE=0) ifadesi, veri kümesinin veri kontrol bloğu özelliklerini belirtir. Burada, RECFM=FB ifadesi veri kümesinin sabit uzunlukta kayıtlara (fixed-length records) sahip olduğunu belirtir. LRECL=150 ifadesi, kayıtların 150 karakter uzunluğunda olduğunu belirtir. BLKSIZE=0 ifadesi ise veri kümesinin blok boyutunun sistem tarafından otomatik olarak belirleneceğini gösterir.



