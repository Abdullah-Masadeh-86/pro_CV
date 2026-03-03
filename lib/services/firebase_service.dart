import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/cv_models.dart';
import '../models/user_model.dart';
import '../firebase_options.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  late final FirebaseAuth _auth;
  late final FirebaseFirestore _firestore;
  late final FirebaseStorage _storage;
  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    await initialize();
  }

  Future<void> initialize() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
    _storage = FirebaseStorage.instance;

    if (kIsWeb) {
      _firestore.settings = const Settings(
        persistenceEnabled: false,
        webExperimentalAutoDetectLongPolling: true,
        webExperimentalForceLongPolling: true,
      );
    }

    _initialized = true;
  }

  // Authentication
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    await _ensureInitialized();
    return await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .timeout(const Duration(seconds: 60));
  }

  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) async {
    await _ensureInitialized();
    return await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .timeout(const Duration(seconds: 60));
  }

  Future<void> signOut() async {
    await _ensureInitialized();
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _ensureInitialized();
    await _auth
        .sendPasswordResetEmail(email: email)
        .timeout(const Duration(seconds: 60));
  }

  // CV Operations
  Future<String> createCV(CV cv) async {
    await _ensureInitialized();
    final docRef = _firestore.collection('cvs').doc();
    await docRef
        .set(cv.copyWith(id: docRef.id).toMap())
        .timeout(const Duration(seconds: 60));
    return docRef.id;
  }

  Future<CV?> getCV(String cvId) async {
    await _ensureInitialized();
    final docSnapshot = await _firestore
        .collection('cvs')
        .doc(cvId)
        .get()
        .timeout(const Duration(seconds: 60));
    if (docSnapshot.exists) {
      return CV.fromMap(docSnapshot.data()!);
    }
    return null;
  }

  Future<List<CV>> getUserCVs(String userId) async {
    await _ensureInitialized();
    final querySnapshot = await _firestore
        .collection('cvs')
        .where('userId', isEqualTo: userId)
        .get()
        .timeout(const Duration(seconds: 60));

    final cvs = querySnapshot.docs.map((doc) => CV.fromMap(doc.data())).toList();
    cvs.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return cvs;
  }

  Future<void> updateCV(CV cv) async {
    await _ensureInitialized();
    await _firestore
        .collection('cvs')
        .doc(cv.id)
        .update(cv.toMap())
        .timeout(const Duration(seconds: 60));
  }

  Future<void> deleteCV(String cvId) async {
    await _ensureInitialized();
    await _firestore
        .collection('cvs')
        .doc(cvId)
        .delete()
        .timeout(const Duration(seconds: 60));
  }

  // File Upload
  Future<String> uploadFile(String filePath, String fileName, Uint8List fileData) async {
    final ref = _storage.ref().child('$filePath/$fileName');
    final uploadTask = await ref.putData(fileData);
    return await uploadTask.ref.getDownloadURL();
  }

  Future<void> deleteFile(String fileUrl) async {
    final ref = _storage.refFromURL(fileUrl);
    await ref.delete();
  }

  // User Management Methods
  Future<List<UserModel>> getAllUsers() async {
    final querySnapshot = await _firestore.collection('users').get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return UserModel.fromMap(data);
    }).toList();
  }

  Future<void> deleteUser(String userId) async {
    // Delete user's CVs first
    final cvs = await getUserCVs(userId);
    for (final cv in cvs) {
      await deleteCV(cv.id);
    }
    
    // Delete user document
    await _firestore.collection('users').doc(userId).delete();
    
    // Delete user from Firebase Auth (if admin has permission)
    try {
      await _auth.currentUser?.delete();
    } catch (e) {
      // Admin might not have permission to delete auth user
    }
  }

  Future<void> toggleUserStatus(String userId, bool isActive) async {
    await _firestore.collection('users').doc(userId).update({
      'isActive': isActive,
    });
  }

  Future<UserModel?> getUserById(String userId) async {
    final docSnapshot = await _firestore.collection('users').doc(userId).get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data()!;
      data['id'] = docSnapshot.id;
      return UserModel.fromMap(data);
    }
    return null;
  }

  Future<void> updateUserRole(String userId, String role) async {
    await _firestore.collection('users').doc(userId).update({
      'role': role,
    });
  }

  Future<void> updateUserSubscription(String userId, String subscription) async {
    await _firestore.collection('users').doc(userId).update({
      'subscription': subscription,
    });
  }
}
