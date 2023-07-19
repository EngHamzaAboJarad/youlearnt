import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you_learnt/entities/transction_model.dart';
import 'package:you_learnt/entities/wallet_account_model.dart';
import 'package:you_learnt/features/_profile/withdraw/teacher_withdraw_options/view.dart';
import 'package:you_learnt/features/_profile/withdraw/wallet/add_new_wallet/view.dart';
import 'package:you_learnt/features/_profile/withdraw/wallet/wallet_list/view.dart';

import '../../../data/remote/api_requests.dart';
import '../../../utils/error_handler/error_handler.dart';
import '../../../utils/functions.dart';
import '../../_auth/logic.dart';
import '../../_main/logic.dart';
import '../../payment/view.dart';
import '../view_profile/logic.dart';

class WithdrawDepositLogic extends GetxController {
  final ApiRequests _apiRequests = Get.find();
  final MainLogic mainLogic = Get.find();
  final AuthLogic authLogic = Get.find();
  // final ViewProfileLogic viewProfileLogic = Get.find();
  // final ViewProfileLogic viewProfileLogic = Get.put(ViewProfileLogic());
  bool isLoading = false;
  List<WalletAccountModel> walletAccountsList = [];
  List<String> accountsTypeList = ["wise", "pioneer"];
  String selectAccountType = "wise";
  String? accountId = "";

  final TextEditingController emailController = TextEditingController();
  final TextEditingController accountHolderController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController routongNumberController = TextEditingController();
  final TextEditingController swiftBicController = TextEditingController();
  final TextEditingController withdrawAmountController =
      TextEditingController();

  final TextEditingController withdrawPaypalEmailController =
      TextEditingController();

  final TextEditingController chargeAmountController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
    onRefresh();
    log("disposee");
  }

  @override
  void onInit() {
    // getTeacherWallets();
    transactionListController.addListener(() {
      if (transactionListController.position.pixels ==
          transactionListController.position.maxScrollExtent) {
        print("from inist satate");

        if (!isThereNextPage) return;
        getTransctionList(false);
      }
    });
    super.onInit();
  }

// moving routes
  goToTeacherWithdrawOptions() {
    Get.to(const ProfileTeacherWithdrawOptions());
  }

  goToAddWallet() {
    Get.to(AddWalletAccountPage(
      edit: false,
    ));
  }

  goToTeacherWalletsList() {
    Get.to(const TeacherWalletsList());
  }

  Future<void> getTeacherWallets() async {
    isLoading = true;
    update();
    try {
      var res = await _apiRequests.getTeacherWallets();
      walletAccountsList = (res.data["records"] as List)
          .map((e) => WalletAccountModel.fromJson(e))
          .toList();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update();
  }

// withdraw request
  onChangeCategory(String val) {
    selectAccountType = val;
    update(['addWalletAccount']);
  }

  WalletAccountModel? selectedAccountToPay;
  onSelectAccountToWithdrae(WalletAccountModel val) {
    selectedAccountToPay = val;
    update(['withdraw_request']);
  }

  Future addWithdrawRequest() async {
    if (selectedAccountToPay == null) {
      showMessage("Wallet is empty.", 2);
      return;
    }
    isLoading = true;
    update(['withdraw_request']);
    try {
      var res = await _apiRequests.withdrawWalletRequest(
          ammount: withdrawAmountController.text,
          accountModel: selectedAccountToPay!);
      selectedAccountToPay = null;
      withdrawAmountController.text = "";
      //  Get.back();
      Get.back();
      showMessage(res.data['message'].toString(), 1);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update(['withdraw_request']);
  }

  Future addWithdrawPayplayRequest() async {
    isLoading = true;
    update(['withdraw_paypal']);
    try {
      var res = await _apiRequests.withdrawPaypalRequest(
          ammount: withdrawAmountController.text,
          paypalEmail: withdrawPaypalEmailController.text);
      withdrawPaypalEmailController.text = "";
      withdrawAmountController.text = "";
      //  Get.back();
      Get.back();
      showMessage(res.data['message'].toString(), 1);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update(['withdraw_paypal']);
  }

  // end withdraw request

  editAccountWallet(WalletAccountModel accountModel) async {
    selectAccountType = accountModel.type;
    emailController.text = accountModel.email;
    accountNumberController.text = accountModel.accountNumber;
    accountHolderController.text = accountModel.accountHodler ?? "";
    routongNumberController.text = accountModel.routingNumber ?? "";
    swiftBicController.text = accountModel.swiftBic ?? "";
    accountId = accountModel.id;

    Get.to(AddWalletAccountPage(
      edit: true,
    ));
  }

  void addWalletAccount(bool edit) async {
    isLoading = true;
    update(['addWalletAccount']);
    try {
      var res = await _apiRequests.addAccountTowallet(edit,
          type: selectAccountType,
          accountId: accountId,
          email: emailController.text,
          accountNumber: accountNumberController.text,
          accountHolder: accountHolderController.text,
          routingNumber: routongNumberController.text,
          swiftBic: swiftBicController.text);

      selectAccountType = "wise";
      emailController.text = "";
      accountNumberController.text = "";
      accountHolderController.text = "";
      routongNumberController.text = "";
      swiftBicController.text = "";

      await getTeacherWallets();
      Get.back();
      showMessage(res.data['message'].toString(), 1);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update(['addWalletAccount']);
  }

  Future<void> deleteWalletAccount(String accountId) async {
    isLoading = true;
    update();
    try {
      var res = await _apiRequests.deleteAcoountWallet(accountId);
      await getTeacherWallets();
      showMessage(res.data['message'].toString(), 1);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update();
  }

  List<String> transactionStatusTypeList = ["pending", "cancelled", "success"];
  int? selectedTransactionStatusTypeIndex;

  // transction
  onChangeStatusType(int? index) {
    selectedTransactionStatusTypeIndex = index;
    update(['transction']);
    transctionPage = 1;
    getTransctionList(false);
  }

  List<String> transactionypeList = [
    "withdraw",
    "credit",
  ];
  int? selectedTransactionTypeIndex;
  // transction
  onChangeTranctionsType(int? index) {
    selectedTransactionTypeIndex = index;
    update(['transction']);
    transctionPage = 1;
    getTransctionList(false);
  }

  int transctionPage = 1;
  List<TransctionModel> transactionList = [];
  final ScrollController transactionListController = ScrollController();
  bool isThereNextPage = true;

  onRefresh() {
    transactionList.clear();
    transctionPage = 1;
    selectedTransactionTypeIndex = null;
    selectedTransactionStatusTypeIndex = null;
    getTransctionList(false);
  }

  Future<void> getTransctionList(bool firstTime) async {
    if (firstTime) {
      transactionList.clear();
      transctionPage = 1;
      selectedTransactionTypeIndex = null;
      selectedTransactionStatusTypeIndex = null;
    }
    isLoading = true;
    update(["transction"]);
    try {
      var res = await _apiRequests.getTransctionsList(
        page: transctionPage,
        status: selectedTransactionStatusTypeIndex == null
            ? null
            : transactionStatusTypeList[selectedTransactionStatusTypeIndex!],
        type: selectedTransactionTypeIndex == null
            ? null
            : transactionypeList[selectedTransactionTypeIndex!],
      );

      // log(res.data.toString());
      if (transctionPage == 1) {
        transactionList = (res.data["records"]["data"] as List)
            .map((e) => TransctionModel.fromJson(e))
            .toList();

        log("first page");
        // transactionList
        //     .addAll(transactionList + transactionList + transactionList);
      } else {
        transactionList.addAll((res.data["records"]["data"] as List)
            .map((e) => TransctionModel.fromJson(e))
            .toList());

        log("next pages");
      }

      isThereNextPage =
          res.data["records"]["next_page_url"] == null ? false : true;

      transctionPage++;
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update(["transction"]);
  }

// charge wallet

  //  0 == stripe , 1 == paypal
  int selectedChargeMethodIndex = 0;

  onChangeSelectedChargeMethod(int index) {
    selectedChargeMethodIndex = index;
    update(["charge-wallet"]);
  }

  Future chargeStudent({required ComeFrom comeFrom}) async {
    switch (selectedChargeMethodIndex) {
      case 0:
        chargeStripe(comeFrom: comeFrom);
        break;
      case 1:
        chargePaybal(comeFrom: comeFrom);
        break;
      default:
    }
  }

  Future chargePaybal({required ComeFrom comeFrom}) async {
    isLoading = true;
    update(['charge-wallet']);
    try {
      var res = await _apiRequests.chargePaypalepage(
          ammount: chargeAmountController.text);

      await Get.to(PaymentScreen(
        url: res.data.toString(),
        comeFrom: comeFrom,
      ));

      chargeAmountController.text = "";
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update(['charge-wallet']);
  }

  Future chargeStripe({required ComeFrom comeFrom}) async {
    isLoading = true;
    update(['charge-wallet']);
    try {
      if (mainLogic.userModel == null) {
        isLoading = false;
        update(['charge-wallet']);
        // showMessage(text, type)
        return;
      }
      log(mainLogic.userModel!.id.toString());
      var res = await _apiRequests.chargeStripePage(
          userId: mainLogic.userModel!.id.toString());

      await Get.to(PaymentScreen(
        url: res.data.toString(),
        comeFrom: comeFrom,
      ));
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update(['charge-wallet']);
  }

  int? selectedPackageTypeIndex;
  bool hasEnoughCredit = false;

  refreshDataAfterBuying() async {
    try {
      selectedPackageTypeIndex = 0;
      // hasEnoughCredit = false;
      final status = await Get.find<ViewProfileLogic>()
          .checkifTheUserHasEnoughCreditToBookPackage(
              selectedPackageIndex: selectedPackageTypeIndex!);
      hasEnoughCredit = status;
    } catch (e) {
      ErrorHandler.handleError(e);
      hasEnoughCredit = false;
    }
    isLoading = false;
    update(['buy-pakage']);
  }

  // transction
  onChangeSelectedPackageType(int? index) async {
    try {
      isLoading = true;
      update(['buy-pakage']);
      selectedPackageTypeIndex = index;
      // final ViewProfileLogic viewProfileLogic = Get.find();
      final status = await Get.find<ViewProfileLogic>()
          .checkifTheUserHasEnoughCreditToBookPackage(
              selectedPackageIndex: index!);

      log(status.toString());
      hasEnoughCredit = status;
    } catch (e) {
      ErrorHandler.handleError(e);
      hasEnoughCredit = false;
    }
    isLoading = false;
    update(['buy-pakage']);
  }
}
