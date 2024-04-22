import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signalbyt/main.dart';
import 'z_card.dart';
import '../pages/subsciption/subscription_page.dart';

import '../constants/app_colors.dart';
import '../models/signal_aggr_open.dart';
import '../utils/z_format.dart';

class ZSignalSubscribeCard extends StatefulWidget {
  ZSignalSubscribeCard({Key? key, required this.signal}) : super(key: key);
  final Signal signal;

  @override
  State<ZSignalSubscribeCard> createState() => _ZSignalSubscribeCardState();
}

class _ZSignalSubscribeCardState extends State<ZSignalSubscribeCard> {
  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    return Column(
      children: [
        ZCard(
          padding: EdgeInsets.all(10),
          borderRadiusColor:
              isLightTheme ? appColorCardBorderLight : appColorCardBorderDark,
          margin: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Container(
                  //   decoration:
                  //       BoxDecoration(color: widget.signal.entryType == 'Long' ? appColorGreen : appColorRed, borderRadius: BorderRadius.circular(5)),
                  //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  //   margin: EdgeInsets.only(bottom: 3),
                  //   child: Text('${widget.signal.entryType.toUpperCase()} !!!', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                  // ),
                  SizedBox(width: 6),
                  Text(
                    widget.signal.symbol,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16, height: 0),
                  ),
                  SizedBox(width: 6),
                  Text(
                    '${ZFormat.dateFormatSignal(widget.signal.entryDateTime)}',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall!.color,
                        fontSize: 13),
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(height: 8),
              Visibility(
                visible: isSubscriptionPackageLoad,
                child: ZCard(
                  color: isLightTheme ? Colors.grey : Colors.white,
                  onTap: () =>
                      Get.to(() => SubscriptionPage(), fullscreenDialog: true),
                  margin: EdgeInsets.only(left: 0, right: 0, bottom: 0),
                  padding: EdgeInsets.symmetric(horizontal: 70, vertical: 8),
                  child: Text('Tap to join Premium',
                      style: TextStyle(color: Colors.black)),
                ),
              ),
            ],
          ),
        ),

        // SizedBox(height: 8),
        // Divider(color: Colors.white12, height: 10, thickness: 1)
      ],
    );
  }
}
