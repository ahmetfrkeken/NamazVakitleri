import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:namazvakti/data/models/namaz_vakti_model.dart';
import 'package:namazvakti/l10n/locale_keys.g.dart';
import 'package:namazvakti/utils/extensions.dart';
import 'package:namazvakti/widgets/display_text.dart';

class DisplayPrayerTimesList extends StatelessWidget {
  final List<NamazVaktiData>? data;
  final Map<String, int>? indices;
  final vakitIsimleri = [
    LocaleKeys.imsak.tr(),
    LocaleKeys.sabah.tr(),
    LocaleKeys.ogle.tr(),
    LocaleKeys.ikindi.tr(),
    LocaleKeys.aksam.tr(),
    LocaleKeys.yatsi.tr()
  ];

  DisplayPrayerTimesList({
    Key? key,
    this.data,
    this.indices,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 2),
          color: Colors.white),
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: data != null ? data!.first.times.length : 1,
        itemBuilder: (context, index) {
          if (data != null) {
            return SizedBox(
              width: ((context.deviceSize.width - 32.0) / 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DisplayText(
                      text: vakitIsimleri[index],
                      fontSize: 8,
                      textColor: index == indices!['indexTime']!
                          ? Colors.red
                          : Colors.black),
                  DisplayText(
                    text: data!.first.times[index],
                    textColor: index == indices!['indexTime']!
                        ? Colors.red
                        : Colors.black,
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
