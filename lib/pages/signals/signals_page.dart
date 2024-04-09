import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ironsource_mediation/ironsource_mediation.dart';
import 'package:provider/provider.dart';
import 'package:signalbyt/utils/ironsourceutils.dart';
import 'package:signalbyt/utils/unityadsutils.dart';
import '../../components/z_signal_subscribe_card.dart';
import '../../models/auth_user.dart';
import '../../models/signal_aggr_open.dart';
import '../../models_providers/auth_provider.dart';
import 'signals_closed_page.dart';

import '../../components/z_card.dart';
import '../../components/z_signal_card.dart';
import '../../components/z_signalaggr_performace_card.dart';
import '../../constants/app_colors.dart';

class SignalsPage extends StatefulWidget {
  SignalsPage(
      {Key? key,
      required this.type,
      required this.signalsAggrOpen,
      required this.controllerLength})
      : super(key: key);
  final String type;
  final List<SignalAggrOpen> signalsAggrOpen;
  final int controllerLength;

  @override
  State<SignalsPage> createState() => _SignalsPageState();
}

class _SignalsPageState extends State<SignalsPage>
    with TickerProviderStateMixin {
  String search = '';
  bool isLoadingInit = true;
  int signalsCount = 0;
  late TabController _controller;
  String? selectSignalAggrId;

  @override
  void initState() {
    _controller = TabController(length: widget.controllerLength, vsync: this);
    if (widget.signalsAggrOpen.length > 0)
      selectSignalAggrId = widget.signalsAggrOpen[0].id;

    _controller = TabController(length: widget.controllerLength, vsync: this);
    _controller.addListener(() {
      int index = _controller.index;
      selectSignalAggrId = widget.signalsAggrOpen[index].id;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ObjectKey(widget.key),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Open Signals',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, height: 1)),
              ],
            ),
          ],
        ),
        actions: [
          Center(
            child: ZCard(
              onTap: () {
                Get.to(() => SignalsClosedPage(type: selectSignalAggrId ?? ''),
                    fullscreenDialog: true,
                    duration: Duration(milliseconds: 500));
                // UnityAdsServices.showRewarded();
                // IronsourceUtils.showInterstitial();
              },
              color: Colors.transparent,
              shadowColor: Colors.transparent,
              inkColor: Colors.transparent,
              child: Text('Results',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
              margin: EdgeInsets.only(right: 16),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              borderRadiusColor: AppCOLORS.yellow,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _controller,
          indicatorColor: appColorYellow,
          labelColor: appColorYellow,
          tabs: [
            for (var s in widget.signalsAggrOpen) Tab(text: '${s.name}'),
          ],
          dividerColor: Colors.transparent,
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          for (var s in widget.signalsAggrOpen) _buildList(s.signals, s),
        ],
      ),
    );
  }

  _buildList(List<Signal> signals, SignalAggrOpen signalAggrOpen) {
    if (signals.isEmpty)
      return Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 3),
          Center(child: Text('No signals available')),
        ],
      );
    return _buildListView(signals, signalAggrOpen);
  }

  Scrollbar _buildListView(
      List<Signal> signals, SignalAggrOpen signalAggrOpen) {
    ScrollController scrollController =
        ScrollController(initialScrollOffset: 0);
    return Scrollbar(
      controller: scrollController,
      child: ListView.builder(
        controller: scrollController,
        itemCount: signals.length,
        itemBuilder: ((context, index) => Column(
              children: [
                if (index == 0)
                  Column(
                    children: [
                      SizedBox(height: 4),
                      ZSignalAggrPerformaceCard(signalAggrOpen: signalAggrOpen)
                    ],
                  ),
                getSignalCard(signals[index]),
                if (index == signals.length - 1) SizedBox(height: 32),
              ],
            )),
      ),
    );
  }

  List<Signal> getFilteredSignals(String s, List<Signal> signals) {
    if (s == '') return signals;
    return signals.where((signal) {
      return signal.symbol.toLowerCase().contains(s.toLowerCase());
    }).toList();
  }

  getSignalCard(Signal signal) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    AuthUser? user = authProvider.authUser;

    if (user?.hasActiveSubscription == true) return ZSignalCard(signal: signal);
    if (signal.isFree) return ZSignalCard(signal: signal);

    return ZSignalSubscribeCard(signal: signal);
  }
}

class ShowEngineBottomSheet extends StatefulWidget {
  ShowEngineBottomSheet({Key? key, required this.type}) : super(key: key);
  final String type;

  @override
  State<ShowEngineBottomSheet> createState() => _ShowEngineBottomSheetState();
}

class _ShowEngineBottomSheetState extends State<ShowEngineBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Text('Please select an engine below',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Spacer(),
              ZCard(
                color: Colors.transparent,
                onTap: (() => Get.back()),
                child: Icon(AntDesign.close, size: 20),
                margin: EdgeInsets.zero,
                padding: EdgeInsets.all(6),
              ),
            ],
          ),
          // _buildSignalWrapper(signalAggrs, 'Crypto Engines'),
        ],
      ),
    );
  }

  buildEngineItem(SignalAggrOpen signalAggr) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    return Column(
      children: [
        SizedBox(height: 12),
        ZCard(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Get.back();
            // if (widget.type == 'long') appProvider.setSelectSignalAggrIdLong(signalAggr.id);
            // if (widget.type == 'short') appProvider.setSelectSignalAggrIdShort(signalAggr.id);
          },
          margin: EdgeInsets.symmetric(vertical: 2),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('${signalAggr.name}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  SizedBox(width: 8),
                  Spacer(),
                  SvgPicture.asset('assets/svg/exchange.svg',
                      colorFilter: ColorFilter.mode(
                          isLightTheme ? Colors.black54 : Colors.white,
                          BlendMode.srcIn),
                      height: 16,
                      width: 16),
                ],
              ),
              Divider(height: 20),
              Text(signalAggr.name, style: TextStyle(fontSize: 14, height: 1.5))
            ],
          ),
        ),
      ],
    );
  }
}
