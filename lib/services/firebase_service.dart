import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import '../models/revenue_model.dart';
import '../models/contract_model.dart';
import '../models/communication_model.dart';
import '../constants/app_config.dart';

class FirebaseService {
  static final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  static firebase_auth.User? get currentUser => _auth.currentUser;

  // Sign up with email and password
  static Future<firebase_auth.UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      firebase_auth.UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

             // Create user document in Firestore
       await _firestore.collection('users').doc(userCredential.user!.uid).set({
         'id': userCredential.user!.uid,
         'name': name,
         'email': email,
         'role': 'Team Owner',
         'ownershipPercentage': 0.0,
         'totalInvestment': 0.0,
         'teamId': AppConfig.teamId,
         'status': 'pending',
         'createdAt': FieldValue.serverTimestamp(),
         'updatedAt': FieldValue.serverTimestamp(),
       });

      return userCredential;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Sign in with email and password
  static Future<firebase_auth.UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      firebase_auth.UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if user is approved
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        await _auth.signOut();
        throw 'User not found in database';
      }

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      String status = userData['status'] ?? 'pending';

      if (status == 'pending') {
        await _auth.signOut();
        throw 'Your account is pending approval. Please wait for admin approval.';
      }

      if (status == 'rejected') {
        await _auth.signOut();
        throw 'Your account has been rejected. Please contact support.';
      }

      return userCredential;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Sign out
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get user data from Firestore
  static Future<User?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return User.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Get team-specific revenue data
  static Stream<QuerySnapshot> getTeamRevenueData() {
    return _firestore
        .collection('revenue')
        .where('teamId', isEqualTo: AppConfig.teamId)
        .orderBy('date', descending: true)
        .snapshots();
  }

  // Add new revenue data
  static Future<void> addRevenueData(RevenueData revenueData) async {
    try {
      await _firestore.collection('revenue').add({
        'id': revenueData.id,
        'season': revenueData.season,
        'ticketSales': revenueData.ticketSales,
        'merchandise': revenueData.merchandise,
        'sponsorships': revenueData.sponsorships,
        'advertising': revenueData.advertising,
        'totalRevenue': revenueData.totalRevenue,
        'date': revenueData.date.toIso8601String(),
        'teamId': AppConfig.teamId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding revenue data: $e');
      throw 'Failed to add revenue data';
    }
  }

  // Update revenue data
  static Future<void> updateRevenueData(String docId, RevenueData revenueData) async {
    try {
      await _firestore.collection('revenue').doc(docId).update({
        'season': revenueData.season,
        'ticketSales': revenueData.ticketSales,
        'merchandise': revenueData.merchandise,
        'sponsorships': revenueData.sponsorships,
        'advertising': revenueData.advertising,
        'totalRevenue': revenueData.totalRevenue,
        'date': revenueData.date.toIso8601String(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating revenue data: $e');
      throw 'Failed to update revenue data';
    }
  }

  // Delete revenue data
  static Future<void> deleteRevenueData(String docId) async {
    try {
      await _firestore.collection('revenue').doc(docId).delete();
    } catch (e) {
      print('Error deleting revenue data: $e');
      throw 'Failed to delete revenue data';
    }
  }

  // Get team-specific contracts
  static Stream<QuerySnapshot> getTeamContracts() {
    return _firestore
        .collection('contracts')
        .where('teamId', isEqualTo: AppConfig.teamId)
        .orderBy('startDate', descending: true)
        .snapshots();
  }

  // Get contract by ID
  static Future<Contract?> getContractById(String docId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('contracts').doc(docId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return Contract.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error getting contract by ID: $e');
      throw 'Failed to get contract';
    }
  }

  // Add new contract
  static Future<void> addContract(Contract contract) async {
    try {
      await _firestore.collection('contracts').add({
        'id': contract.id,
        'name': contract.name,
        'type': contract.type,
        'position': contract.position,
        'salary': contract.salary,
        'startDate': contract.startDate.toIso8601String(),
        'endDate': contract.endDate.toIso8601String(),
        'status': contract.status,
        'teamId': AppConfig.teamId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding contract: $e');
      throw 'Failed to add contract';
    }
  }

  // Update contract
  static Future<void> updateContract(String docId, Contract contract) async {
    try {
      await _firestore.collection('contracts').doc(docId).update({
        'name': contract.name,
        'type': contract.type,
        'position': contract.position,
        'salary': contract.salary,
        'startDate': contract.startDate.toIso8601String(),
        'endDate': contract.endDate.toIso8601String(),
        'status': contract.status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating contract: $e');
      throw 'Failed to update contract';
    }
  }

  // Delete contract
  static Future<void> deleteContract(String docId) async {
    try {
      await _firestore.collection('contracts').doc(docId).delete();
    } catch (e) {
      print('Error deleting contract: $e');
      throw 'Failed to delete contract';
    }
  }

  // Update contract status
  static Future<void> updateContractStatus(String docId, String newStatus) async {
    try {
      // First check if the contract exists
      final docRef = _firestore.collection('contracts').doc(docId);
      final docSnapshot = await docRef.get();
      
      if (!docSnapshot.exists) {
        throw 'Contract not found. It may have been deleted or the ID is incorrect.';
      }
      
      // Update the contract status
      await docRef.update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating contract status: $e');
      if (e.toString().contains('not-found')) {
        throw 'Contract not found. It may have been deleted or the ID is incorrect.';
      } else if (e.toString().contains('permission-denied')) {
        throw 'Permission denied. You may not have access to update this contract.';
      } else {
        throw 'Failed to update contract status: $e';
      }
    }
  }

  // Communication Methods
  // Get team communications
  static Stream<QuerySnapshot> getTeamCommunications() {
    return _firestore
        .collection('communications')
        .where('teamId', isEqualTo: AppConfig.teamId)
        .where('status', isEqualTo: 'published')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Get communications by type
  static Stream<QuerySnapshot> getCommunicationsByType(CommunicationType type) {
    return _firestore
        .collection('communications')
        .where('teamId', isEqualTo: AppConfig.teamId)
        .where('type', isEqualTo: type.toString().split('.').last)
        .where('status', isEqualTo: 'published')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Get user-specific communications
  static Stream<QuerySnapshot> getUserCommunications(String userId) {
    return _firestore
        .collection('communications')
        .where('teamId', isEqualTo: AppConfig.teamId)
        .where('recipients', arrayContains: userId)
        .where('status', isEqualTo: 'published')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Get urgent communications
  static Stream<QuerySnapshot> getUrgentCommunications() {
    return _firestore
        .collection('communications')
        .where('teamId', isEqualTo: AppConfig.teamId)
        .where('priority', whereIn: ['high', 'urgent'])
        .where('status', isEqualTo: 'published')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Add new communication
  static Future<void> addCommunication(Communication communication) async {
    try {
      await _firestore.collection('communications').add({
        'id': communication.id,
        'title': communication.title,
        'content': communication.content,
        'type': communication.type.toString().split('.').last,
        'priority': communication.priority.toString().split('.').last,
        'status': communication.status.toString().split('.').last,
        'authorId': communication.authorId,
        'authorName': communication.authorName,
        'teamId': communication.teamId,
        'recipients': communication.recipients,
        'tags': communication.tags,
        'metadata': communication.metadata,
        'createdAt': Timestamp.fromDate(communication.createdAt),
        'publishedAt': communication.publishedAt != null 
            ? Timestamp.fromDate(communication.publishedAt!) 
            : null,
        'expiresAt': communication.expiresAt != null 
            ? Timestamp.fromDate(communication.expiresAt!) 
            : null,
        'updatedAt': Timestamp.fromDate(communication.updatedAt),
        'requiresAcknowledgement': communication.requiresAcknowledgement,
        'acknowledgedBy': communication.acknowledgedBy,
        'attachments': communication.attachments,
        'viewCount': communication.viewCount,
        'viewedBy': communication.viewedBy,
      });
    } catch (e) {
      print('Error adding communication: $e');
      throw 'Failed to add communication';
    }
  }

  // Update communication
  static Future<void> updateCommunication(String docId, Communication communication) async {
    try {
      await _firestore.collection('communications').doc(docId).update({
        'title': communication.title,
        'content': communication.content,
        'type': communication.type.toString().split('.').last,
        'priority': communication.priority.toString().split('.').last,
        'status': communication.status.toString().split('.').last,
        'recipients': communication.recipients,
        'tags': communication.tags,
        'metadata': communication.metadata,
        'publishedAt': communication.publishedAt != null 
            ? Timestamp.fromDate(communication.publishedAt!) 
            : null,
        'expiresAt': communication.expiresAt != null 
            ? Timestamp.fromDate(communication.expiresAt!) 
            : null,
        'updatedAt': Timestamp.fromDate(communication.updatedAt),
        'requiresAcknowledgement': communication.requiresAcknowledgement,
        'acknowledgedBy': communication.acknowledgedBy,
        'attachments': communication.attachments,
        'viewCount': communication.viewCount,
        'viewedBy': communication.viewedBy,
      });
    } catch (e) {
      print('Error updating communication: $e');
      throw 'Failed to update communication';
    }
  }

  // Delete communication
  static Future<void> deleteCommunication(String docId) async {
    try {
      await _firestore.collection('communications').doc(docId).delete();
    } catch (e) {
      print('Error deleting communication: $e');
      throw 'Failed to delete communication';
    }
  }

  // Mark communication as viewed
  static Future<void> markCommunicationAsViewed(String docId, String userId) async {
    try {
      await _firestore.collection('communications').doc(docId).update({
        'viewCount': FieldValue.increment(1),
        'viewedBy': FieldValue.arrayUnion([userId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error marking communication as viewed: $e');
      throw 'Failed to mark communication as viewed';
    }
  }

  // Acknowledge communication
  static Future<void> acknowledgeCommunication(String docId, String userId) async {
    try {
      await _firestore.collection('communications').doc(docId).update({
        'acknowledgedBy': FieldValue.arrayUnion([userId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error acknowledging communication: $e');
      throw 'Failed to acknowledge communication';
    }
  }



  // Get team dashboard stats
  static Future<Map<String, dynamic>> getTeamDashboardStats() async {
    try {
      // Get counts from different collections
      final revenueQuery = await _firestore
          .collection('revenue')
          .where('teamId', isEqualTo: AppConfig.teamId)
          .get();
      
      final contractsQuery = await _firestore
          .collection('contracts')
          .where('teamId', isEqualTo: AppConfig.teamId)
          .get();
      
      final communicationsQuery = await _firestore
          .collection('communications')
          .where('teamId', isEqualTo: AppConfig.teamId)
          .where('status', isEqualTo: 'published')
          .get();
      
      final usersQuery = await _firestore
          .collection('users')
          .where('teamId', isEqualTo: AppConfig.teamId)
          .get();

      // Calculate total revenue
      double totalRevenue = 0;
      for (var doc in revenueQuery.docs) {
        final data = doc.data();
        totalRevenue += (data['totalRevenue'] ?? 0).toDouble();
      }

      // Calculate active contracts
      int activeContracts = 0;
      for (var doc in contractsQuery.docs) {
        final data = doc.data();
        if (data['status'] == 'active') {
          activeContracts++;
        }
      }

      // Calculate urgent communications
      int urgentCommunications = 0;
      for (var doc in communicationsQuery.docs) {
        final data = doc.data();
        if (data['priority'] == 'high' || data['priority'] == 'urgent') {
          urgentCommunications++;
        }
      }

      return {
        'totalRevenue': totalRevenue,
        'totalContracts': contractsQuery.docs.length,
        'activeContracts': activeContracts,
        'totalCommunications': communicationsQuery.docs.length,
        'urgentCommunications': urgentCommunications,
        'totalUsers': usersQuery.docs.length,
        'pendingUsers': usersQuery.docs.where((doc) => 
            (doc.data()['status'] ?? '') == 'pending').length,
      };
    } catch (e) {
      print('Error getting dashboard stats: $e');
      throw 'Failed to get dashboard stats';
    }
  }

  // Get all users for admin (team-specific)
  static Stream<QuerySnapshot> getAllTeamUsers() {
    return _firestore
        .collection('users')
        .where('teamId', isEqualTo: AppConfig.teamId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Update user status (for admin use)
  static Future<void> updateUserStatus(String uid, String status) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating user status: $e');
      throw 'Failed to update user status';
    }
  }

  // Update user status and ownership details (for admin use)
  static Future<void> updateUserStatusAndDetails(String uid, String status, double ownershipPercentage, double totalInvestment) async {
    try {
      // Check if this would exceed 100% total ownership
      if (status == 'approved') {
        final currentTotal = await _getTotalApprovedOwnership();
        final userDoc = await _firestore.collection('users').doc(uid).get();
        final currentUserOwnership = userDoc.exists ? (userDoc.data()?['ownershipPercentage'] ?? 0.0) : 0.0;
        final newTotal = currentTotal - currentUserOwnership + ownershipPercentage;
        
        if (newTotal > 100.0) {
          throw 'Total ownership would exceed 100%. Current total: ${currentTotal.toStringAsFixed(1)}%, this would make it: ${newTotal.toStringAsFixed(1)}%';
        }
      }
      
      await _firestore.collection('users').doc(uid).update({
        'status': status,
        'ownershipPercentage': ownershipPercentage,
        'totalInvestment': totalInvestment,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating user status and details: $e');
      throw 'Failed to update user status and details: $e';
    }
  }

  // Get total ownership percentage of all approved users
  static Future<double> _getTotalApprovedOwnership() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('status', isEqualTo: 'approved')
          .get();
      
      double total = 0.0;
      for (var doc in querySnapshot.docs) {
        total += (doc.data()['ownershipPercentage'] ?? 0.0);
      }
      return total;
    } catch (e) {
      print('Error getting total approved ownership: $e');
      return 0.0;
    }
  }

  // Get all pending users (for admin use)
  static Stream<QuerySnapshot> getPendingUsers() {
    return _firestore
        .collection('users')
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Handle Firebase Auth errors
  static String _handleAuthError(dynamic error) {
    // Check if it's our custom success message
    if (error is String && error.contains('Account created successfully')) {
      return error;
    }
    
    if (error is firebase_auth.FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No user found with this email address.';
        case 'wrong-password':
          return 'Wrong password provided.';
        case 'email-already-in-use':
          return 'An account already exists with this email address.';
        case 'weak-password':
          return 'The password provided is too weak.';
        case 'invalid-email':
          return 'The email address is invalid.';
        case 'user-disabled':
          return 'This user account has been disabled.';
        case 'too-many-requests':
          return 'Too many requests. Please try again later.';
        case 'operation-not-allowed':
          return 'Email/password accounts are not enabled.';
        case 'invalid-credential':
          return 'Invalid email or password.';
        case 'account-exists-with-different-credential':
          return 'An account already exists with the same email address but different sign-in credentials.';
        default:
          return error.message ?? 'An error occurred during authentication.';
      }
    }
    return error.toString();
  }

  // Check if user is authenticated
  static bool get isAuthenticated => _auth.currentUser != null;

  // Get authentication state changes
  static Stream<firebase_auth.User?> get authStateChanges => _auth.authStateChanges();

  // Google Sign-In
  static Future<firebase_auth.UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw 'Google Sign-In was cancelled';
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      firebase_auth.UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Check if user exists in Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        // Create new user document for Google Sign-In
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'id': userCredential.user!.uid,
          'name': userCredential.user!.displayName ?? 'Unknown User',
          'email': userCredential.user!.email,
          'role': 'Team Owner',
          'ownershipPercentage': 0.0,
          'totalInvestment': 0.0,
          'teamId': AppConfig.teamId,
          'status': 'pending',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        
        // Sign out immediately for new users (they need admin approval)
        await _auth.signOut();
        throw 'Account created successfully! Please wait for admin approval.';
      } else {
        // Check approval status for existing user
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        String status = userData['status'] ?? 'pending';

        if (status == 'pending') {
          await _auth.signOut();
          throw 'Your account is pending approval. Please wait for admin approval.';
        }

        if (status == 'rejected') {
          await _auth.signOut();
          throw 'Your account has been rejected. Please contact support.';
        }
      }

      return userCredential;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }
}
