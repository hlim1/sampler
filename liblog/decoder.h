#ifndef INCLUDE_sampler_liblog_decoder_h
#define INCLUDE_sampler_liblog_decoder_h

#ifdef __cplusplus
extern "C" {
#endif // C++


void siteCountdown(unsigned);
void siteFile(const char *);
void siteLine(unsigned);
void siteEnd();

void sampleExpr(const char *);

void sampleChar(char);
void sampleSignedChar(signed char);
void sampleUnsignedChar(unsigned char);
void sampleInt(int);
void sampleUnsignedInt(unsigned int);
void sampleShort(short);
void sampleUnsignedShort(unsigned short);
void sampleLong(long);
void sampleUnsignedLong(unsigned long);
void sampleLongLong(long long);
void sampleUnsignedLongLong(unsigned long long);
void sampleFloat(float);
void sampleDouble(double);
void sampleLongDouble(long double);
void samplePointer(const void *);


#ifdef __cplusplus
}
#endif // C++

#endif // !INCLUDE_sampler_liblog_decoder_h
