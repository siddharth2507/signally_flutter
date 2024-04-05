import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'z_card.dart';
import '../models/signal_aggr_open.dart';
import '../pages/signals/signal_analysis_page.dart';

import '../models_providers/app_controls_provider.dart';
import '../pages/user/tradingview_page.dart';
import '../utils/Z_get_pips_percent.dart';
import '../utils/z_format.dart';
import '../constants/app_colors.dart';
import 'package:configurable_expansion_tile_null_safety/configurable_expansion_tile_null_safety.dart';

class ZSignalCard extends StatefulWidget {
  ZSignalCard({Key? key, required this.signal}) : super(key: key);
  final Signal signal;

  @override
  State<ZSignalCard> createState() => _ZSignalCardState();
}

class _ZSignalCardState extends State<ZSignalCard> {
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
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.transparent),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Opened:'),
                    Spacer(),
                    Text(
                      '${ZFormat.dateFormatSignal(widget.signal.entryDateTime)}',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall!.color,
                          fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: widget.signal.entryType == 'Long'
                              ? appColorGreen
                              : appColorRed,
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                      margin: EdgeInsets.only(bottom: 3),
                      child: Text('${widget.signal.entryType.toUpperCase()} !!',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                              color: Colors.white)),
                    ),
                    SizedBox(width: 6),
                    Text(
                      widget.signal.symbol,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14, height: 0),
                    ),
                    Spacer(),
                    getStatus(widget.signal),
                  ],
                ),
                SizedBox(height: 8),
                Row(children: [
                  Text(
                    'Entry price',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall!.color),
                  ),
                  SizedBox(width: 4),
                  Spacer(),
                  SizedBox(width: 4),
                  Text(widget.signal.entryPrice.toString()),
                ]),
                SizedBox(height: 8),
                Row(children: [
                  Text(
                    'Stop Loss',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall!.color),
                  ),
                  SizedBox(width: 4),
                  Text(getPipsOrPercentStr(
                    isPips: widget.signal.market == 'forex' ? true : false,
                    pips: widget.signal.stopLossPips,
                    percent: widget.signal.stopLossPct,
                  )),
                  Spacer(),
                  SizedBox(width: 4),
                  Text('${ZFormat.toPrecision(widget.signal.stopLoss, 8)}'),
                ]),
                SizedBox(height: 8),
                ConfigurableExpansionTile(
                  headerExpanded: Flexible(
                    child: _buildTargetCurrentPrice(false),
                  ),
                  header: (bool isExpanded,
                          Animation<double> iconTurns,
                          Animation<double> heightFactor,
                          ConfigurableExpansionTileController controller) =>
                      Flexible(
                    child: _buildTargetCurrentPrice(true),
                  ),
                  childrenBody: Column(
                    children: [
                      SizedBox(height: 8),
                      _buildTargetCard(
                          name: 'Target 1',
                          target: widget.signal.takeProfit1,
                          targetPct: widget.signal.takeProfit1Pct,
                          targetPips: widget.signal.takeProfit1Pips,
                          result: widget.signal.takeProfit1Result,
                          resultTimeUtc: widget.signal.takeProfit1DateTime,
                          signal: widget.signal),
                      _buildTargetCard(
                          name: 'Target 2',
                          target: widget.signal.takeProfit2,
                          targetPct: widget.signal.takeProfit2Pct,
                          targetPips: widget.signal.takeProfit2Pips,
                          result: widget.signal.takeProfit2Result,
                          resultTimeUtc: widget.signal.takeProfit2DateTime,
                          signal: widget.signal),
                      _buildTargetCard(
                          name: 'Target 3',
                          target: widget.signal.takeProfit3,
                          targetPct: widget.signal.takeProfit3Pct,
                          targetPips: widget.signal.takeProfit3Pips,
                          result: widget.signal.takeProfit3Result,
                          resultTimeUtc: widget.signal.takeProfit3DateTime,
                          signal: widget.signal),
                      SizedBox(height: 12),
                      Row(children: [Text(getStatusText(widget.signal))]),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
                if (widget.signal.comment != '')
                  Column(
                    children: [
                      SizedBox(height: 8),
                      Text('Comment: ${widget.signal.comment}')
                    ],
                  ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ZCard(
                        borderRadiusColor: isLightTheme
                            ? appColorCardBorderLight
                            : appColorCardBorderDark,
                        color: isLightTheme
                            ? appColorCardButtonLight
                            : appColorCardButtonDark,
                        onTap: () => Get.to(
                            () => TradingViewPage(symbol: widget.signal.symbol),
                            fullscreenDialog: true),
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('View Chart',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5)),
                            SizedBox(width: 4),
                            Icon(AntDesign.piechart, size: 14),
                          ],
                        ),
                        margin: EdgeInsets.zero,
                      ),
                    ),
                    if (widget.signal.gerHasAnalysis()) SizedBox(width: 8),
                    if (widget.signal.gerHasAnalysis())
                      Expanded(
                        child: ZCard(
                          borderRadiusColor: isLightTheme
                              ? appColorCardBorderLight
                              : appColorCardBorderDark,
                          color: isLightTheme
                              ? appColorCardButtonLight
                              : appColorCardButtonDark,
                          onTap: () => Get.to(
                              () => SignalAnalysisPage(signal: widget.signal),
                              fullscreenDialog: true),
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('View Analysis',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5)),
                              SizedBox(width: 4),
                              Icon(MaterialIcons.computer, size: 14),
                            ],
                          ),
                          margin: EdgeInsets.zero,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildTargetCurrentPrice(bool isExpanded) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final AppControlsProvider appControlsProvider =
        Provider.of<AppControlsProvider>(context);
    final hasApiAccess = appControlsProvider.appControls.apiHasAccess;
    final isForex = widget.signal.market == 'forex';
    final entryVsCurrentPrice = widget.signal.compareEntryPriceWithCurrentPrice(
        price: appControlsProvider.getWSSymbolPrice(widget.signal),
        isPips: isForex);

    return ZCard(
      padding: EdgeInsets.symmetric(vertical: 9, horizontal: 12),
      borderRadiusColor:
          isLightTheme ? appColorCardBorderLight : appColorCardBorderDark,
      color: isLightTheme ? appColorCardButtonLight : appColorCardButtonDark,
      margin: EdgeInsets.zero,
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * .375,
            child: Text(hasApiAccess ? "Current Price" : 'Targets',
                style: TextStyle()),
          ),
          if (hasApiAccess)
            Text(appControlsProvider.getWSSymbolPrice(widget.signal).toString(),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
          Spacer(),
          if (hasApiAccess)
            Text(
              getPipsOrPercentStr(
                isPips: isForex,
                pips: entryVsCurrentPrice,
                percent: entryVsCurrentPrice,
              ),
              style: TextStyle(
                  color: entryVsCurrentPrice < 0 ? appColorRed : appColorGreen,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          SizedBox(width: 4),
          Icon(isExpanded ? Icons.arrow_drop_down : Icons.arrow_drop_up,
              size: 25),
        ],
      ),
    );
  }

  _buildTargetCard({
    required String name,
    required String result,
    required num target,
    required num targetPct,
    required num targetPips,
    required DateTime? resultTimeUtc,
    required Signal signal,
  }) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: result == 'profit'
            ? appColorGreen.withOpacity(.4)
            : isLightTheme
                ? appColorCardButtonLight
                : appColorCardButtonDark,
      ),
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(children: [
        Container(
          width: MediaQuery.of(context).size.width * .375,
          child: Text('${name}',
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall!.color,
                  fontWeight: FontWeight.bold)),
        ),
        SizedBox(width: 4),
        Text('${ZFormat.toPrecision(target, 8)}'),
        Spacer(),
        Text(
            getPipsOrPercentStr(
              isPips: widget.signal.market == 'forex' ? true : false,
              pips: targetPips,
              percent: targetPct,
            ),
            style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall!.color,
                fontWeight: FontWeight.bold)),
        if (result == 'profit')
          Icon(Icons.check,
              color: Theme.of(context).textTheme.bodySmall!.color, size: 16),
      ]),
    );
  }

  getStatus(Signal signal) {
    if (signal.takeProfit3Hit)
      return _buildStatusContainer(text: 'Target 3', isProfit: true);
    if (signal.takeProfit2Hit)
      return _buildStatusContainer(text: 'Target 2', isProfit: true);
    if (signal.takeProfit1Hit)
      return _buildStatusContainer(text: 'Target 1', isProfit: true);
    if (signal.stopLossHit)
      return _buildStatusContainer(text: 'Stop Loss hit', isProfit: false);
    return _buildStatusContainer(
        text: 'In progress', isProfit: true, isInProgress: true);
  }

  String getStatusText(Signal signal) {
    if (signal.takeProfit3Hit)
      return 'Bagged full profit  ${ZFormat.dateFormatSignal(signal.takeProfit3DateTime)}';
    if (signal.takeProfit2Hit)
      return 'Bagged target 2 profit  ${ZFormat.dateFormatSignal(signal.takeProfit2DateTime)}';
    if (signal.takeProfit1Hit)
      return 'Bagged target 1 profit  ${ZFormat.dateFormatSignal(signal.takeProfit1DateTime)}';
    if (signal.stopLossHit)
      return 'Stopped out @ ${ZFormat.dateFormatSignal(signal.takeProfit1DateTime)}';
    return 'In progress';
  }

  _buildStatusContainer(
      {required String text,
      required bool isProfit,
      bool isInProgress = false}) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    if (isInProgress)
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: isLightTheme ? Colors.grey.shade200 : Colors.white),
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          children: [
            Text(text,
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    height: 1.35)),
            SizedBox(width: 4),
            Icon(isProfit ? Icons.incomplete_circle_outlined : Icons.close,
                color: Colors.black54, size: 12),
          ],
        ),
      );
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: isProfit ? appColorGreen : Color(0XFF332229),
      ),
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          Text(text,
              style: TextStyle(
                  color: isProfit ? Colors.white70 : Color(0xFFFF637E),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  height: 1.35)),
          SizedBox(width: 4),
          Icon(isProfit ? Icons.check : Icons.close,
              color: isProfit ? Colors.white70 : Color(0xFFFF637E), size: 12),
        ],
      ),
    );
  }
}
