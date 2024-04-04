import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:networking/models/account_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class APIsAuth {
  static FirebaseStorage fireStorage = FirebaseStorage.instance;

  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  static Future<bool> checkContainsAccount(String loginName) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listAccRead = await _prefs.getStringList('accounts') ?? [];
    for (var acc in listAccRead) {
      Account account = Account.fromMap(jsonDecode(acc));
      if ((account.loginName!.length == loginName.length) &&
          (account.loginName == loginName)) return true;
    }
    return false;
  }

  static Future<void> createNewAccount(String loginName, String password,
      String question, String answer, String userId) async {
    final SharedPreferences _prefs = await prefs;
    final newAccount = Account(
        loginName: loginName,
        userId: userId,
        email: '',
        password: password,
        question: question,
        answer: answer,
        createdAt: DateTime.now(),
        updateAt: null,
        deleteAt: null);
    List<String> listAccRead = await _prefs.getStringList('accounts') ?? [];
    listAccRead.add(jsonEncode(newAccount.toMap()));
    await _prefs.setStringList('accounts', listAccRead);
    await _prefs.setBool('logged', true);
    await _prefs.setString('currentUserId', newAccount.userId!);

    // final listAcc = await _prefs.getStringList('accounts') ?? [];
    // print(listAcc);
  }

  static Future<Account?> getAccountFromLoginName(String loginName) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listAccRead = await _prefs.getStringList('accounts') ?? [];
    for (var acc in listAccRead) {
      Account account = Account.fromMap(jsonDecode(acc));
      if ((account.loginName!.length == loginName.length) &&
          (account.loginName == loginName)) return account;
    }
    return null;
  }

  static Future<void> updateAccount() async {
    // final SharedPreferences _prefs = await prefs;
  }

  static Future<void> resetPassword(
      String loginName, String newPassword) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listAccRead = await _prefs.getStringList('accounts') ?? [];
    for (var acc in listAccRead) {
      Account account = Account.fromMap(jsonDecode(acc));
      if ((account.loginName!.length == loginName.length) &&
          (account.loginName == loginName)) {
        account.password = newPassword;
        account.updateAt = DateTime.now();
        listAccRead.remove(acc);
        listAccRead.add(jsonEncode(account.toMap()));
        await _prefs.setStringList('accounts', listAccRead);
        return;
      }
    }
  }

  static Future<void> deleteAccount() async {
    final SharedPreferences _prefs = await prefs;
    await _prefs.clear();
  }

  static Future<bool> login(String loginName, String password) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listAccRead = await _prefs.getStringList('accounts') ?? [];
    // List<Account> listAccParse =
    //     listAccRead.map((e) => Account.fromMap(jsonDecode(e))).toList();
    for (var account in listAccRead) {
      Account acc = Account.fromMap(jsonDecode(account));
      if ((acc.loginName!.length == loginName.length) &&
          (acc.loginName == loginName) &&
          (acc.password!.length == password.length) &&
          (acc.password == password)) {
        await _prefs.setString('currentUserId', acc.userId!);
        await _prefs.setBool('logged', true);
        return true;
      }
    }
    return false;
  }

  static Future<String?> getCurrentUserId() async {
    final SharedPreferences _prefs = await prefs;
    return await _prefs.getString('currentUserId');
  }

  static Future<void> logout() async {
    final SharedPreferences _prefs = await prefs;
    await _prefs.setBool('logged', false);
  }
}
