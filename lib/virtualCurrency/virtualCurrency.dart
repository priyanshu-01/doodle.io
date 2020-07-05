import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'data.dart';

class VirtualCurrency extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var currency = Provider.of<Currency>(context);
    return VirtualCurrencyChanger(
      currency: currency,
    );
  }
}

class VirtualCurrencyChanger extends StatefulWidget {
  final Currency currency;
  VirtualCurrencyChanger({this.currency});
  @override
  _VirtualCurrencyChangerState createState() => _VirtualCurrencyChangerState();
}

class _VirtualCurrencyChangerState extends State<VirtualCurrencyChanger>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  int temp;
  @override
  void initState() {
    controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500),
        lowerBound: 0.0,
        upperBound: 1.0)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.currency.lastValueCoins = widget.currency.remainingCoins;
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currency.lastValueCoins != widget.currency.remainingCoins &&
        !controller.isAnimating) {
      int diff =
          widget.currency.lastValueCoins - widget.currency.remainingCoins;
      diff = diff * 10;
      controller.duration = Duration(milliseconds: diff.abs());
      controller.forward(from: 0.0);
    }

    return Container(
      // color: Colors.white,
      height: 40.0,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: const Image(
              image: AssetImage('assets/icons/coin.png'),
            ),
          ),
          AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                if (widget.currency.lastValueCoins <
                    widget.currency.remainingCoins) {
                  temp = ((widget.currency.remainingCoins -
                              widget.currency.lastValueCoins) *
                          controller.value)
                      .toInt();
                  temp = temp + widget.currency.lastValueCoins;
                } else {
                  temp = ((widget.currency.lastValueCoins -
                              widget.currency.remainingCoins) *
                          controller.value)
                      .toInt();
                  temp = widget.currency.lastValueCoins - temp;
                }
                return Text(
                  commas(temp),
                  style: GoogleFonts.fredokaOne(
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w400,
                      color: widget.currency.coinsAmountColor),
                );
              }
              //  },
              ),
          SizedBox(
            width: 5.0,
          )
        ],
      ),
    );
  }
}

// below is for constant currency view

class VirtualCurrencyContent extends StatelessWidget {
  final Currency currency;
  VirtualCurrencyContent({this.currency});
  @override
  Widget build(BuildContext context) {
    print('currency changed');
    return Container(
        height: 40.0,
        // color: Colors.white,
        // width: 100.0,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: const Image(
                image: AssetImage('assets/icons/coin.png'),
              ),
            ),
            Text(
              commas(currency.remainingCoins),
              style: GoogleFonts.fredokaOne(
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            ),
            SizedBox(
              width: 5.0,
            )
          ],
        ));
  }
}

String commas(int n) {
  String c = n.toString();
  String r;
  if (c.length <= 3)
    r = c;
  else if (c.length == 4) {
    r = c.substring(0, 1) + ',' + c.substring(1);
  } else if (c.length == 5) {
    r = c.substring(0, 2) + ',' + c.substring(2);
  } else if (c.length == 6) {
    r = c.substring(0, 1) + ',' + c.substring(1, 3) + ',' + c.substring(3);
  } else if (c.length == 7) {
    r = c.substring(0, 2) + ',' + c.substring(2, 4) + ',' + c.substring(4);
  } else
    r = c;
  return r;
}
