import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/auth_response_model.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/user_model.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST('/auth/login')
  Future<AuthResponseModel> login(@Body() LoginRequest request);

  @POST('/auth/register')
  Future<AuthResponseModel> register(@Body() RegisterRequest request);

  @GET('/auth/profile')
  Future<UserModel> getProfile();
}
