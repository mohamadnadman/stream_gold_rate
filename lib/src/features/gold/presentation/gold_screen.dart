import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class GoldScreen extends StatefulWidget {
  const GoldScreen({super.key});
  @override
  State<GoldScreen> createState() => _GoldScreenState();
}
class _GoldScreenState extends State<GoldScreen> {
  late Stream<double> _goldPriceStream;
  late double _currentGoldPrice;
  late bool _isLoading;
  late String _errorMessage;
  @override
  void initState() {
    super.initState();
    _goldPriceStream = getGoldPriceStream();
    _currentGoldPrice = 0.0;
    _isLoading = true;
    _errorMessage = '';
    // Initialisieren Sie den Stream-Listener
    _goldPriceStream.listen((double price) {
      setState(() {
        _currentGoldPrice = price;
        _isLoading = false;
        _errorMessage = '';
      });
    }, onError: (dynamic error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Fehler beim Laden des Goldpreises';
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              Text(
                'Live Kurs:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              _buildGoldPriceWidget(),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildGoldPriceWidget() {
    if (_isLoading) {
      return const CircularProgressIndicator();
    } else if (_errorMessage.isNotEmpty) {
      return Text(
        _errorMessage,
        style: const TextStyle(color: Colors.red),
      );
    } else {
      return Text(
        NumberFormat.simpleCurrency(locale: 'de_DE').format(_currentGoldPrice),
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(color: Theme.of(context).colorScheme.primary),
      );
    }
  }
  Row _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Image(
          image: AssetImage('assets/bars.png'),
          width: 100,
        ),
        const SizedBox(width: 10),
        Text(
          'Gold',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}
Stream<double> getGoldPriceStream() {
  Random random = Random();
  return Stream<double>.periodic(
    const Duration(seconds: 1),
    (int _) {
      return 60 + random.nextDouble() * 20;
    },
  );
}