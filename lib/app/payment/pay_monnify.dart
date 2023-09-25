import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_monnify/flutter_monnify.dart';

class PayWithMonnify extends StatefulWidget {
  const PayWithMonnify({super.key});

  @override
  State<PayWithMonnify> createState() => _PayWithMonnifyState();
}

class _PayWithMonnifyState extends State<PayWithMonnify> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SizedBox(
      width: width,
      height: height,
      child: Center(
        child: TextButton(
          child: const Text("Pay With Monnify SDK"),
          onPressed: () async {
            TransactionResponse? response = await Monnify().checkout(
                context, monnifyPayload(),
                appBar: AppBarConfig(
                    titleColor: Colors.white, backgroundColor: Colors.red),
                toast: ToastConfig(
                    color: Colors.black, backgroundColor: Colors.red));

            //call the backend to verify transaction status before providing value
            if (kDebugMode) {
              print("Future completed======>${response?.toJson().toString()}");
              print("Future completed11======>${response?.message.toString()}");
            }
          },
        ),
      ),
    ));
  }

  Map<String, dynamic> monnifyPayload() {
    return {
      "amount": 100,
      "currency": "NGN",
      "reference": DateTime.now().toIso8601String(),
      "customerFullName": "John Doe",
      "customerEmail": "customer@gmail.com",
      "apiKey": "MK_TEST_595UN92CCV",
      "contractCode": "8628159341",
      "paymentDescription": "Lahray World",
      "metadata": {"name": "Damilare", "age": 45},
      // "incomeSplitConfig": [
      //   {
      //     "subAccountCode": "MFY_SUB_342113621921",
      //     "feePercentage": 50,
      //     "splitAmount": 1900,
      //     "feeBearer": true
      //   },
      //   {
      //     "subAccountCode": "MFY_SUB_342113621922",
      //     "feePercentage": 50,
      //     "splitAmount": 2100,
      //     "feeBearer": true
      //   }
      // ],
      "paymentMethod": ["CARD", "ACCOUNT_TRANSFER", "USSD", "PHONE_NUMBER"],
    };
  }
}
