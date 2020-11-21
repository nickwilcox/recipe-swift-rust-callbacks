#ifndef BridgingHeader_h
#define BridgingHeader_h

#import <Foundation/Foundation.h>

typedef struct CompletedCallback {
    void * _Nonnull userdata;
    void (* _Nonnull callback)(void * _Nonnull, bool);
} CompletedCallback;

void async_operation(CompletedCallback callback);

#endif