import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'z_card.dart';
import '../models_providers/app_controls_provider.dart';
import '../utils/z_format.dart';

import '../models/signal_aggr_open.dart';

class ZSignalAggrPerformaceCard extends StatelessWidget {
  const ZSignalAggrPerformaceCard({super.key, required this.signalAggrOpen});
  final SignalAggrOpen signalAggrOpen;

  @override
  Widget build(BuildContext context) {
    final trades7Days = signalAggrOpen.performance7Days?.trades ?? 0;
    final trades7DaysStr = trades7Days > 0 ? trades7Days.toString() : '---';
    final trades14Days = signalAggrOpen.performance14Days?.trades ?? 0;
    final trades14DaysStr = trades14Days > 0 ? trades14Days.toString() : '---';
    final trades30Days = signalAggrOpen.performance30Days?.trades ?? 0;
    final trades30DaysStr = trades30Days > 0 ? trades30Days.toString() : '---';

    final winRate7Days = signalAggrOpen.performance7Days?.winRate ?? 0;
    final winRate7DaysStr = winRate7Days != 0 ? ZFormat.numToPercent(winRate7Days) : '---';
    final winRate14Days = signalAggrOpen.performance14Days?.winRate ?? 0;
    final winRate14DaysStr = winRate14Days != 0 ? ZFormat.numToPercent(winRate14Days) : '---';
    final winRate30Days = signalAggrOpen.performance30Days?.winRate ?? 0;
    final winRate30DaysStr = winRate30Days != 0 ? ZFormat.numToPercent(winRate30Days) : '---';

    AppControlsProvider appControlsProvider = Provider.of<AppControlsProvider>(context);
    final appControls = appControlsProvider.appControls;

    if (appControls.showSignalAggrPerformance)
      return ZCard(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (appControls.showSignalAggrPerformance7Days)
            Row(
              children: [
                Text('Trades last   7 days: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Text(trades7DaysStr, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Spacer(),
                Text('Win rate: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Text(winRate7DaysStr, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          SizedBox(height: 4),
          if (appControls.showSignalAggrPerformance14Days)
            Row(
              children: [
                Text('Trades last 14 days: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Text(trades14DaysStr, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Spacer(),
                Text('Win rate: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Text(winRate14DaysStr, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          SizedBox(height: 4),
          if (appControls.showSignalAggrPerformance30Days)
            Row(
              children: [
                Text('Trades last 30 days: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Text(trades30DaysStr, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Spacer(),
                Text('Win rate: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Text(winRate30DaysStr, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
        ],
      ));

    return Container();
  }
}
