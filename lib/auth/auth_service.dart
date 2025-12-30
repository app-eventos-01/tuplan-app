import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  static const _onboardingKeyPrefix = 'onboarding_complete_';

  static String onboardingKeyForUser(String userId) {
    return '$_onboardingKeyPrefix$userId';
  }

  final SupabaseClient _client = Supabase.instance.client;

  Future<void> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: _redirectTo,
    );
  }

  Future<void> signInWithApple() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.apple,
      redirectTo: _redirectTo,
    );
  }

  String? get _redirectTo {
    if (kIsWeb) {
      return Uri.base.toString();
    }
    return null;
  }

  Future<ProfileBootstrapResult> ensureProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return const ProfileBootstrapResult(isNewUser: false);
    }

    final profile = await _client
        .from('profiles')
        .select('id')
        .eq('id', user.id)
        .maybeSingle();

    if (profile == null) {
      await _client.from('profiles').insert({
        'id': user.id,
        'email': user.email,
        'full_name': user.userMetadata?['full_name'] ??
            user.userMetadata?['name'],
        'avatar_url': user.userMetadata?['avatar_url'] ??
            user.userMetadata?['picture'],
        'provider': user.appMetadata['provider'],
      });
      return const ProfileBootstrapResult(isNewUser: true);
    }

    return const ProfileBootstrapResult(isNewUser: false);
  }
}

class ProfileBootstrapResult {
  const ProfileBootstrapResult({required this.isNewUser});

  final bool isNewUser;
}