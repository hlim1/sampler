#ifndef INCLUDE_sampler_liblog_decoder_h
#define INCLUDE_sampler_liblog_decoder_h

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif // C++


enum DecoderResult { Normal = 0, Abnormal, Garbled };

#define YY_DECL enum DecoderResult yylex()
YY_DECL;

void siteCountdown(unsigned);
void siteFile(const char *);
void siteLine(unsigned);
void siteEnd();

void sampleExpr(const char *);

void sampleInt8(int8_t);
void sampleUInt8(uint8_t);
void sampleInt16(int16_t);
void sampleUInt16(uint16_t);
void sampleInt32(int32_t);
void sampleUInt32(uint32_t);
void sampleInt64(int64_t);
void sampleUInt64(uint64_t);

void sampleFloat32(float);
void sampleFloat64(double);
void sampleFloat96(long double);

void samplePointer32(const void *);


#ifdef __cplusplus
}
#endif // C++

#endif // !INCLUDE_sampler_liblog_decoder_h
