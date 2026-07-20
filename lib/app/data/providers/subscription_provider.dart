import 'package:dio/dio.dart';
import 'package:subsync/app/core/network/api_client.dart';

class SubscriptionProvider {
  final ApiClient _apiClient = ApiClient();

  Future<Response> getAllSubscriptions() async {
    return await _apiClient.get('/subscriptions');
  }

  Future<Response> getSubscription(String id) async {
    return await _apiClient.get('/subscriptions/$id');
  }

  Future<Response> cancelSubscription(String id) async {
    return await _apiClient.put('/subscriptions/$id/cancel');
  }
}
