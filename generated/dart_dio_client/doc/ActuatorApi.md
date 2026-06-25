# espacio_ciudadano_api.api.ActuatorApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**health**](ActuatorApi.md#health) | **GET** /actuator/health | Actuator web endpoint &#39;health&#39;
[**healthPath**](ActuatorApi.md#healthpath) | **GET** /actuator/health/** | Actuator web endpoint &#39;health-path&#39;
[**links**](ActuatorApi.md#links) | **GET** /actuator | Actuator root web endpoint


# **health**
> JsonObject health()

Actuator web endpoint 'health'

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getActuatorApi();

try {
    final response = api.health();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ActuatorApi->health: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/vnd.spring-boot.actuator.v2+json, application/vnd.spring-boot.actuator.v3+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **healthPath**
> JsonObject healthPath()

Actuator web endpoint 'health-path'

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getActuatorApi();

try {
    final response = api.healthPath();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ActuatorApi->healthPath: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/vnd.spring-boot.actuator.v2+json, application/vnd.spring-boot.actuator.v3+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **links**
> BuiltMap<String, BuiltMap<String, Link>> links()

Actuator root web endpoint

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getActuatorApi();

try {
    final response = api.links();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ActuatorApi->links: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltMap&lt;String, BuiltMap&lt;String, Link&gt;&gt;**](BuiltMap.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/vnd.spring-boot.actuator.v2+json, application/vnd.spring-boot.actuator.v3+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

