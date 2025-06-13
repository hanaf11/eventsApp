import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:eventsappadmin/models/dobavljac.dart';
import 'package:eventsappadmin/models/slika.dart';
import 'package:eventsappadmin/models/tipkarte.dart';
import 'package:eventsappadmin/providers/dobavljac_provider.dart';
import 'package:eventsappadmin/providers/dogadjaj_provider.dart';
import 'package:eventsappadmin/providers/kategorija_provider.dart';
import 'package:eventsappadmin/providers/podkategorija_provider.dart';
import 'package:eventsappadmin/providers/tipkarte_provider.dart';
import 'package:eventsappadmin/screens/dogadjaji_list_screen.dart';
import 'package:eventsappadmin/screens/zahtjevi_list_screen.dart';
import 'package:eventsappadmin/utils/util.dart';
import 'package:eventsappadmin/widgets/button_widget.dart';
import 'package:eventsappadmin/widgets/master_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:provider/provider.dart';
import 'package:flutter_nominatim/flutter_nominatim.dart';

import '../models/dogadjaj.dart';
import '../models/kategorija.dart';
import '../models/podkategorija.dart';
import '../models/search_result.dart';
import '../providers/galerija_provider.dart';

class DogadjajiDetailsScreen extends StatefulWidget {
  int? dogadjajId;
  bool? zahtjev;
  Function() refresh;
  DogadjajiDetailsScreen(
      {this.dogadjajId, this.zahtjev, required this.refresh, super.key});

  @override
  State<DogadjajiDetailsScreen> createState() => _DogadjajiDetailsScreenState();
}

class _DogadjajiDetailsScreenState extends State<DogadjajiDetailsScreen> {
  late KategorijaProvider _kategorijaProvider;
  late DogadjajProvider _dogadjajProvider;
  late PodkategorijaProvider _podkategorijaProvider;
  late GalerijaProvider _galerijaProvider;
  late TipkarteProvider _tipKarteProvider;
  late DobavljacProvider _dobavljacProvider;
  final _formKey = GlobalKey<FormBuilderState>();
  FormBuilderState? _formStateCopy;
  Map<String, dynamic> _initialValue = {};
  SearchResult<Kategorija>? kategorijeResult;
  SearchResult<Podkategorija>? podkategorijeResult;
  Dobavljac? dobavljacResult;
  SearchResult<TipKarte>? tipKarteResult;
  bool isLoading = true;
  bool _fetching = false;
  bool showBackButton = true;
  bool _deleted = false;
  int? kategorija;
  Dogadjaj? dogadjaj;
  ImageObj? _naslovna;
  ImageObj? _programSlika;
  ImageObj? _lokacijaSlika;
  List<Slika> galleryItems = [];
  bool podkategorijeLoaded = false;
  int? selectedPodkategorija;
  final GlobalKey<ButtonWidgetState> saveButtonKey =
      GlobalKey<ButtonWidgetState>();
  final GlobalKey<ButtonWidgetState> deleteButtonKey =
      GlobalKey<ButtonWidgetState>();
  final GlobalKey<ButtonWidgetState> rejectButtonKey =
      GlobalKey<ButtonWidgetState>();
  final GlobalKey<ButtonWidgetState> acceptButtonKey =
      GlobalKey<ButtonWidgetState>();
  late Nominatim nominatim;

  @override
  void initState() {
    super.initState();

    /*_initialValue = {
      'naziv': widget.dogadjaj?.naziv,
      'opis': widget.dogadjaj?.opis,
      'program': widget.dogadjaj?.program,
      'kategorijaId': widget.dogadjaj?.kategorijaId,
      'podkategorijaId': widget.dogadjaj?.podkategorijaId,
      'lokacija': widget.dogadjaj?.lokacija,
      'datumOd': widget.dogadjaj?.datumOd,
      'datumDo': widget.dogadjaj?.datumDo,
      'website': widget.dogadjaj?.website,
      'organizator': widget.dogadjaj?.organizator
    };*/
    nominatim = Nominatim.instance;
    _kategorijaProvider = context.read<KategorijaProvider>();
    _dogadjajProvider = context.read<DogadjajProvider>();
    _podkategorijaProvider = context.read<PodkategorijaProvider>();
    _galerijaProvider = context.read<GalerijaProvider>();
    _tipKarteProvider = context.read<TipkarteProvider>();
    _dobavljacProvider = context.read<DobavljacProvider>();
    initForm(widget.dogadjajId);
    deleteButtonKey.currentState?.setDeleted(false);
    saveButtonKey.currentState?.setDeleted(false);
    acceptButtonKey.currentState?.setDeleted(false);
    rejectButtonKey.currentState?.setDeleted(false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  /*kategorijaChanged(value) async {
    setState(() {
      kategorija = value;
      _initialValue['podkategorijaId'] = null;
    });
    await _podkategorijaProvider
        .get(filter: {'kategorijaId': kategorija}).then((value) => setState(
              () {
                podkategorijeResult = value;
              },
            ));
  }*/

  kategorijaChanged(value) async {
    if (value != null && value != kategorija) {
      setState(() {
        podkategorijeLoaded = false;
        kategorija = value;
        //   _formKey.currentState!.fields['PodkategorijaId']. =dogadjaj?.podkategorijaId;
      });

      await _podkategorijaProvider
          .get(filter: {'kategorijaId': kategorija}).then((value) {
        setState(() {
          podkategorijeResult = value;
          podkategorijeLoaded = true;
        });
      });
    }
  }

  void _handleDeleteSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Successful"),
          content: Text("Događaj je uspješno obrisan"),
          actions: [
            TextButton(
              onPressed: () {
                /*setState(() {
                  _deleted = true;
                });*/
                deleteButtonKey.currentState?.setDeleted(true);
                saveButtonKey.currentState?.setDeleted(true);
                Navigator.of(context).pop();
                widget.refresh();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _handleRejectAcceptSuccess(
      BuildContext context, String msg, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ZahtjeviListScreen(),
                ));
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void handleDogadjajCreated(id) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Success"),
              content: Text("Uspješno ste dodali događaj!"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context), child: Text("OK"))
              ],
            ));
    setState(() {
      widget.dogadjajId = id;
    });
  }

  handleDogadjajUpdated(id) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Success"),
              content: Text("Uspješno ste uredili događaj!"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.refresh();
                    },
                    child: Text("OK"))
              ],
            ));
  }

  handleDogadjajException(Object? e) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Error"),
              content: Text(e?.toString() ?? 'An uknown error occured'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      /*  setState(() {
                        // _fetching = false;
                        _isFetching.value = false;
                      });*/
                    },
                    child: Text("OK"))
              ],
            ));
    // _formKey.currentState?.reset(); //myb for update
  }

  void deleteImage(int index, int? id) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Potvrdite akciju'),
        content: Text('Da li stvarno želite obrisati sliku?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Odustani'),
            child: const Text('Odustani'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Potvrdi');
              if (index >= 0 && index < galleryItems.length) {
                if (id != null) {
                  _galerijaProvider.delete(id).then((value) => {
                        setState(() {
                          galleryItems.removeAt(index);
                        })
                      });
                } else {
                  setState(() {
                    galleryItems.removeAt(index);
                  });
                }
              }

              print(galleryItems.length);
            },
            child: const Text('Potvrdi'),
          ),
        ],
      ),
    );
  }

  Future initForm(dogadjajId) async {
    kategorijeResult = await _kategorijaProvider.get();
    if (dogadjajId != null) {
      dogadjaj = await _dogadjajProvider.getById(dogadjajId);
      await _podkategorijaProvider
          .get(filter: {'kategorijaId': dogadjaj!.kategorijaId}).then((val) {
        setState(() {
          selectedPodkategorija =
              dogadjaj?.podkategorijaId == 0 ? null : dogadjaj?.podkategorijaId;
          podkategorijeResult = val;
          podkategorijeLoaded = true;
        });
        print("evo promijenjeno na $selectedPodkategorija");
      });
      var slikeResult =
          await _galerijaProvider.get(filter: {'dogadjajId': dogadjajId});
      galleryItems = slikeResult.result;
      tipKarteResult =
          await _tipKarteProvider.get(filter: {'DogadjajId': dogadjajId});
      if (dogadjaj?.dobavljacId != null)
        dobavljacResult =
            await _dobavljacProvider.getById(dogadjaj!.dobavljacId!);
    }

    _initialValue = {
      'Naziv': dogadjaj?.naziv,
      'Opis': dogadjaj?.opis,
      'Program': dogadjaj?.program,
      'KategorijaId': dogadjaj?.kategorijaId,
      'PodkategorijaId':
          dogadjaj?.podkategorijaId == 0 ? null : dogadjaj?.podkategorijaId,
      'Lokacija': dogadjaj?.lokacija,
      'DatumOd': dogadjaj?.datumOd,
      'DatumDo': dogadjaj?.datumDo,
      'Website': dogadjaj?.website,
      'Organizator': dogadjaj?.organizator
    };

    if (dogadjaj != null && dogadjaj!.naslovna != null) {
      setState(() {
        _naslovna = ImageObj(
            Image.memory(
              base64Decode(dogadjaj!.naslovna!),
              fit: BoxFit.cover,
            ),
            dogadjaj?.naslovna);
        _initialValue['Naslovna'] = _naslovna!.base64Image;
      });
    } else {
      setState(() {
        _naslovna = defaultImg;
      });
    }

    setState(() {
      /*_programSlika = dogadjaj != null && dogadjaj!.programSlika != null
          ? try{} ImageObj(
              Image.memory(
                base64Decode(dogadjaj!.programSlika!),
                fit: BoxFit.cover,
              ),
              dogadjaj?.programSlika)
          : defaultImg;*/
      _programSlika = dogadjaj != null && dogadjaj!.programSlika != null
          ? loadImageFromMemory(dogadjaj!.programSlika)
          : defaultImg;
      _lokacijaSlika = dogadjaj != null && dogadjaj!.lokacijaSlika != null
          ? loadImageFromMemory(dogadjaj!.lokacijaSlika)
          : defaultImg;
      /*_lokacijaSlika = dogadjaj != null && dogadjaj!.lokacijaSlika != null
          ? ImageObj(
              Image.memory(
                base64Decode(dogadjaj!.lokacijaSlika!),
                fit: BoxFit.cover,
              ),
              dogadjaj?.lokacijaSlika)
          : defaultImg;*/
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        showBackButton: showBackButton,
        selectedIndex: 0,
        child: /*Expanded(
            child: Container(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                    child:
                          Column(children: [
                  isLoading
                      ? const CircularProgressIndicator()
                      : Column(
                          children: [_buildForm(), _buildButtons()],
                        )
                ])
                 
                )))*/
            isLoading
                ? Expanded(
                    child: Center(child: const CircularProgressIndicator()))
                : Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [_buildForm(), _buildButtons()],
                      ),
                    ),
                  ));
  }

  _buildButtons() {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      if (widget.zahtjev != null && widget.zahtjev == true) ...[
        _buildButtonReject(),
        _buildButtonAccept(),
        _buildButtonSave()
      ] else ...[
        _buildButtonDelete(),
        _buildButtonSave()
      ]
    ]);
  }

  getLatLong(String address) async {
    var result = await nominatim.search(address);
    if (result != null && result.isNotEmpty) {
      var lat = result[0].latitude;
      var lon = result[0].longitude;
      print('Latitude: $lat, Longitude: $lon');
      return LatLng(lat, lon);
    } else {
      print('Address not found');
      return const LatLng(0, 0);
    }
  }

  _buildButtonAccept() {
    return ButtonWidget(
      key: acceptButtonKey,
      deleted: _deleted,
      text: "Prihvati",
      onClick: () async {
        try {
          acceptButtonKey.currentState?.fetchingTrue();
          _dogadjajProvider.accept(dogadjaj!.dogadjajId!).then((value) {
            _handleRejectAcceptSuccess(
                context, "Događaj je prihvaćen", "Accept successful");
          });
        } on Exception catch (e) {
          handleDogadjajException(e);
        } finally {
          acceptButtonKey.currentState?.fetchingFalse();
        }
      },
    );
  }

  _buildButtonSave() {
    return ButtonWidget(
        key: saveButtonKey,
        deleted: _deleted,
        text: "Sačuvaj",
        onClick: () async {
          final isFormValid =
              _formKey.currentState?.saveAndValidate(focusOnInvalid: false) ??
                  false;
          if (isFormValid) {
            var request = Map.from(_formKey.currentState!.value);

            var latLong = await getLatLong(request['Lokacija']);
            request['Latitude'] = latLong.latitude;
            request['Longitude'] = latLong.longitude;

            request['DatumOd'] = request['DatumOd']?.toIso8601String();
            request['DatumDo'] = request['DatumDo']?.toIso8601String();
            request['Galerija'] = galleryItems;
            request['ProgramSlika'] = _programSlika?.base64Image;
            request['LokacijaSlika'] = _lokacijaSlika?.base64Image;

            print("request je $request");

            try {
              saveButtonKey.currentState?.fetchingTrue();

              if (widget.dogadjajId == null) {
                await _dogadjajProvider.insert(request).then((value) {
                  handleDogadjajCreated(value.dogadjajId);
                });
              } else {
                await _dogadjajProvider
                    .update(widget.dogadjajId!, request: request)
                    .then((value) {
                  handleDogadjajUpdated(value.dogadjajId);
                });
              }
            } on Exception catch (e) {
              handleDogadjajException(e);
            } finally {
              saveButtonKey.currentState?.fetchingFalse();
            }
          }
        });
  }

  _buildButtonDelete() {
    return ButtonWidget(
      key: deleteButtonKey,
      deleted: _deleted,
      onClick: () async {
        final parentContext = context;
        showDialog<String>(
          context: parentContext,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Potvrdite akciju'),
            content: Text(
                'Da li stvarno želite obrisati događaj ${dogadjaj?.naziv}?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Odustani'),
                child: const Text('Odustani'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context, 'Potvrdi');
                  try {
                    deleteButtonKey.currentState?.fetchingTrue();
                    await _dogadjajProvider
                        .delete(dogadjaj!.dogadjajId!)
                        .then((value) {
                      _handleDeleteSuccess(parentContext);
                    });
                  } on Exception catch (e) {
                    handleDogadjajException(e);
                    print(e);
                  } finally {
                    deleteButtonKey.currentState?.fetchingFalse();
                  }
                },
                child: const Text('Potvrdi'),
              ),
            ],
          ),
        );
      },
      text: "Obriši",
    );
  }

  _buildButtonReject() {
    return ButtonWidget(
      key: rejectButtonKey,
      deleted: _deleted,
      text: "Odbij",
      onClick: () async {
        final parentContext = context;
        showDialog<String>(
          context: parentContext,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Potvrdite akciju'),
            content: Text(
                'Da li stvarno želite odbiti objavljivanje događaja ${dogadjaj?.naziv}?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Odustani'),
                child: const Text('Odustani'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context, 'Potvrdi');
                  try {
                    rejectButtonKey.currentState?.fetchingTrue();

                    _dogadjajProvider.hide(dogadjaj!.dogadjajId!).then((value) {
                      _handleRejectAcceptSuccess(
                          context, "Događaj je odbijen", "Reject Successful");
                    });
                  } on Exception catch (e) {
                    handleDogadjajException(e);
                  } finally {
                    rejectButtonKey.currentState?.fetchingFalse();
                  }
                },
                child: const Text('Potvrdi'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildForm() {
    print("Podkategorije list: ${podkategorijeResult?.result}");

    print("initial value $selectedPodkategorija");
    return Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
            child: FormBuilder(
                key: _formKey,
                initialValue: _initialValue,
                child: Column(
                  children: [
                    Row(children: [
                      _buildInputField(
                        "Naziv:",
                        FormBuilderTextField(
                          name: 'Naziv',
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: 'Polje je obavezno')
                          ]),
                        ),
                      ),
                      _buildInputField(
                          "Lokacija:",
                          FormBuilderTextField(
                            name: 'Lokacija',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: 'Polje je obavezno')
                            ]),
                          ))
                    ]),
                    _buildDatePicker(),
                    Row(
                      children: [
                        _buildInputField(
                            "Kategorija:",
                            FormBuilderDropdown<int>(
                              name: 'KategorijaId',
                              isExpanded: true,
                              /* decoration: InputDecoration(
                              suffix: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  _formKey.currentState!.fields['kategorijaId']
                                      ?.reset();
                                },
                              ),
                            ),*/
                              onChanged: (value) {
                                kategorijaChanged(value);
                              },
                              items: kategorijeResult?.result
                                      .map((item) => DropdownMenuItem(
                                            alignment:
                                                AlignmentDirectional.center,
                                            value: item.kategorijaId,
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(item.naziv ?? "")),
                                          ))
                                      .toList() ??
                                  [],
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                    errorText: 'Polje je obavezno')
                              ]),
                            )),
                        if (podkategorijeLoaded)
                          _buildInputField(
                              "Podkategorija:",
                              FormBuilderDropdown<int?>(
                                initialValue: selectedPodkategorija,
                                name: 'PodkategorijaId',
                                isExpanded: true,
                                items: podkategorijeResult?.result
                                        .map((item) => DropdownMenuItem(
                                              alignment:
                                                  AlignmentDirectional.center,
                                              value: item.podkategorijaId,
                                              child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child:
                                                      Text(item.naziv ?? "")),
                                            ))
                                        .toList() ??
                                    [],
                                onChanged: ((val) {
                                  setState(() {
                                    selectedPodkategorija = val;
                                  });
                                }),
                              ))
                        /*_buildInputField(
                              "Podkategorija:",
                              FormBuilderDropdown<int?>(
                                initialValue: selectedPodkategorija,
                                name: 'PodkategorijaId',
                                isExpanded: true,
                                items: podkategorijeResult?.result
                                        .map((item) => DropdownMenuItem(
                                              alignment:
                                                  AlignmentDirectional.center,
                                              value: item.podkategorijaId,
                                              child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child:
                                                      Text(item.naziv ?? "")),
                                            ))
                                        .toList() ??
                                    [],
                                onChanged: ((val) {
                                  setState(() {
                                    selectedPodkategorija = val;
                                  });
                                }),
                              ))*/
                      ],
                    ),
                    Row(
                      children: [
                        _buildInputField(
                            "Website:",
                            FormBuilderTextField(
                              name: 'Website',
                            )),
                        _buildInputField(
                            "Organizator:",
                            FormBuilderTextField(
                              name: 'Organizator',
                              readOnly: true,
                            ))
                      ],
                    ),
                    Container(
                        height: 250,
                        child: Row(children: [
                          Expanded(
                              child: Column(children: [
                            _buildInputField(
                                "Naslovna:",
                                FormBuilderField(
                                    name: 'Naslovna',
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(
                                          errorText: 'Polje je obavezno')
                                    ]),
                                    builder: ((field) {
                                      return InputDecorator(
                                          decoration: InputDecoration(
                                              errorText: field.errorText),
                                          child: ListTile(
                                              leading: Icon(Icons.photo),
                                              title: Text(
                                                  "Odaberi naslovnu sliku"),
                                              trailing: Icon(Icons.file_upload),
                                              // onTap: getImage,
                                              onTap: () {
                                                getImage((imageObj) {
                                                  setState(() {
                                                    _naslovna = imageObj;
                                                    field.didChange(
                                                        _naslovna?.base64Image);
                                                  });
                                                });
                                              }));
                                    }))),
                            const SizedBox(height: 15),
                            buildNaslovna(),
                            const SizedBox(height: 15),
                          ])),
                          /* _buildInputField(
                            "Galerija:",
                            FormBuilderTextField(
                              name: 'galerija',
                            ))*/
                          Expanded(
                            child: Column(
                              children: [
                                _buildInputField(
                                    "Galerija",
                                    FormBuilderField(
                                        name: 'slika',
                                        builder: ((field) {
                                          return InputDecorator(
                                              decoration: InputDecoration(
                                                  errorText: field.errorText),
                                              child: ListTile(
                                                leading: Icon(Icons.photo),
                                                title: const Text(
                                                    "Dodaj sliku u galeriju"),
                                                trailing:
                                                    Icon(Icons.file_upload),
                                                onTap: addImageGallery,
                                              ));
                                        }))),
                                const SizedBox(height: 15),
                                buildGalerija(),
                                const SizedBox(height: 15),
                                /* Text(
                                "Galerija:",
                                style: TextStyle(
                                    color: Color.fromRGBO(34, 33, 33, 1),
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 8,
                              ),*/
                                //listview
                              ],
                            ),
                          )
                        ])),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        _buildInputField(
                            "Program:",
                            FormBuilderTextField(
                              name: 'Program',
                              maxLines: 5,
                            )),
                        _buildInputField(
                            "Opis:",
                            FormBuilderTextField(
                              name: 'Opis',
                              maxLines: 5,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                    errorText: 'Polje je obavezno')
                              ]),
                            ))
                      ],
                    ),
                    Container(
                        height: 250,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Column(children: [
                                _buildInputField(
                                    "Program slika:",
                                    FormBuilderField(
                                        name: 'ProgramSlika',
                                        builder: ((field) {
                                          return InputDecorator(
                                              decoration: InputDecoration(
                                                  errorText: field.errorText),
                                              child: ListTile(
                                                leading: Icon(Icons.photo),
                                                title: Text(
                                                    "Odaberi program sliku"),
                                                trailing:
                                                    Icon(Icons.file_upload),
                                                onTap: () {
                                                  getImage((imageObj) {
                                                    setState(() {
                                                      _programSlika = imageObj;
                                                    });
                                                  });
                                                },
                                              ));
                                        }))),
                                const SizedBox(height: 15),
                                buildProgramSlika(),
                                const SizedBox(height: 15),
                              ])),
                              Expanded(
                                child: Container(),
                              )
                            ])),
                    SizedBox(
                      height: 40,
                    ),
                    _buildKarteInfo()
                  ],
                )
                /*       Row(
                      children: [
                        Expanded(
                            child: FormBuilderDropdown<int>(
                          name: 'kategorijaId',
                          decoration: InputDecoration(
                            labelText: 'Kategorija',
                            suffix: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                _formKey.currentState!.fields['kategorijaId']
                                    ?.reset();
                              },
                            ),
                            hintText: 'Odaberi kategoriju',
                          ),
                          items: kategorijeResult?.result
                                  .map((item) => DropdownMenuItem(
                                        alignment: AlignmentDirectional.center,
                                        value: item.kategorijaId,
                                        child: Text(item.naziv ?? ""),
                                      ))
                                  .toList() ??
                              [],
                        )),
                      ],
                    ),
                    Row(children: [
                      Expanded(
                          child: FormBuilderField(
                        name: 'naslovna',
                        builder: ((field) {
                          return InputDecorator(
                              decoration: InputDecoration(
                                  label: Text("Odaberite sliku"),
                                  errorText: field.errorText),
                              child: ListTile(
                                leading: Icon(Icons.photo),
                                title: Text("Select image"),
                                trailing: Icon(Icons.file_upload),
                                onTap: getImage,
                              ));
                        }),
                      ))
                    ])*/
                )));
  }

  _buildDatePicker() {
    var validateDate = FormBuilderValidators.compose([
      (value) {
        if (value == null) {
          return 'Polje je obavezno';
        }
        return null;
      },
      (value) {
        if (value is DateTime) {
          print(_formKey.currentState?.fields['DatumOd']?.value);
          if (value.isBefore(DateTime.now())) {
            return 'Datum mora biti u buducnosti';
          }
          if (value.isBefore(_formKey.currentState?.fields['DatumOd']?.value)) {
            return 'Mora biti poslije početnog datuma';
          }
        }
        return null;
      },
    ]);

    return Row(
      children: [
        _buildInputField(
            "Datum od:",
            FormBuilderDateTimePicker(
              name: 'DatumOd',
              validator: validateDate,
            )),
        _buildInputField(
            "Datum do:",
            FormBuilderDateTimePicker(
              name: 'DatumDo',
              validator: validateDate,
            ))
      ],
    );
  }

  _buildKarteInfo() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Informacije o kartama",
        style: TextStyle(
            fontSize: 20,
            color: Color.fromRGBO(34, 33, 33, 1),
            fontWeight: FontWeight.bold),
      ),
      Row(
        children: [
          _buildInputField(
              "Uključena prodaja karata:",
              FormBuilderCheckbox(
                title: Text(""),
                initialValue: dogadjaj?.dobavljacId != null ? true : false,
                name: 'ProdajaKarata',
                enabled: false,
              ))
        ],
      ),
      if (dogadjaj?.dobavljacId != null)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 240,
                    child: Column(children: [
                      _buildInputField(
                          "Slika lokacije:",
                          FormBuilderField(
                              name: 'LokacijaSlika',
                              builder: ((field) {
                                return InputDecorator(
                                    decoration: InputDecoration(
                                        errorText: field.errorText),
                                    child: ListTile(
                                      leading: Icon(Icons.photo),
                                      title: Text("Uredi sliku lokacije"),
                                      trailing: Icon(Icons.file_upload),
                                      onTap: () {
                                        getImage((imageObj) {
                                          setState(() {
                                            _lokacijaSlika = imageObj;
                                          });
                                        });
                                      },
                                    ));
                              }))),
                      const SizedBox(height: 15),
                      buildLokacijaSlika(),
                      const SizedBox(height: 15),
                    ])),
                SizedBox(width: double.infinity, child: _buildTipKarti())
              ],
            )),
            _buildInputField(
                "Dobavljač karti:",
                FormBuilderDropdown<int>(
                    name: 'DobavljacId',
                    isExpanded: true,
                    enabled: false,
                    initialValue: dobavljacResult?.dobavljacId,
                    items: dobavljacResult != null
                        ? [
                            DropdownMenuItem(
                              value: dobavljacResult?.dobavljacId,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(dobavljacResult?.naziv ?? '')),
                            )
                          ]
                        : []))
          ],
        )
    ]);
  }

  /* _buildKarteInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Informacije o kartama",
          style: TextStyle(
              fontSize: 20,
              color: Color.fromRGBO(34, 33, 33, 1),
              fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            _buildInputField(
                "Uključena prodaja karata:",
                FormBuilderCheckbox(
                  title: Text(""),
                  initialValue: dogadjaj?.dobavljacId != null ? true : false,
                  name: 'ProdajaKarata',
                  enabled: false,
                ))
          ],
        ),
        if (dogadjaj?.dobavljacId != null)
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Container()
                /* Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  height: 240,
                  child: Column(children: [
                    _buildInputField(
                        "Slika lokacije:",
                        FormBuilderField(
                            name: 'LokacijaSlika',
                            builder: ((field) {
                              return InputDecorator(
                                  decoration: InputDecoration(
                                      errorText: field.errorText),
                                  child: ListTile(
                                    leading: Icon(Icons.photo),
                                    title: Text("Uredi sliku lokacije"),
                                    trailing: Icon(Icons.file_upload),
                                    onTap: () {
                                      getImage((imageObj) {
                                        setState(() {
                                          _lokacijaSlika = imageObj;
                                        });
                                      });
                                    },
                                  ));
                            }))),
                    const SizedBox(height: 15),
                    buildLokacijaSlika(),
                    const SizedBox(height: 15),
                  ])),*/
                )
            //  _buildTipKarti()
          ]),
        _buildInputField(
            "Dobavljač karti:",
            FormBuilderDropdown<int>(
                name: 'DobavljacId',
                isExpanded: true,
                enabled: false,
                initialValue: dobavljacResult?.dobavljacId,
                items: dobavljacResult != null
                    ? [
                        DropdownMenuItem(
                          value: dobavljacResult?.dobavljacId,
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(dobavljacResult?.naziv ?? '')),
                        )
                      ]
                    : [])),
      ],
    );
    // ]);
  }*/

  _buildTipKarti() {
    return (tipKarteResult != null &&
            tipKarteResult!.result != null &&
            tipKarteResult!.result!.isNotEmpty)
        ? DataTable(
            showCheckboxColumn: false,
            columns: [
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Tip karte',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Cijena',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
            rows: tipKarteResult?.result
                    ?.map((TipKarte e) => DataRow(cells: [
                          DataCell(Text(
                            e.naziv ?? '',
                          )),
                          DataCell(Text(formatNumber(e.cijena))),
                        ]))
                    .toList() ??
                [])
        : Container();
  }

  Widget _buildInputField(String name, Widget field) {
    return Expanded(
      child: Row(children: [
        Text(
          name,
          style: TextStyle(
              color: Color.fromRGBO(34, 33, 33, 1),
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(child: field),
        SizedBox(
          width: 50,
        ),
      ]),
    );
  }

  dynamic buildNaslovna() {
    return Container(
        height: 140,
        width: 400,
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(20)),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20), child: _naslovna?.image));
  }

  dynamic buildProgramSlika() {
    return Container(
        height: 140,
        width: 400,
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(20)),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: _programSlika?.image));
  }

  dynamic buildLokacijaSlika() {
    return Container(
        height: 140,
        width: 400,
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(20)),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: _lokacijaSlika?.image));
  }

  Widget buildGalerija() {
    return Container(
        height: 140,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: galleryItems.length,
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          itemBuilder: (context, index) =>
              buildCard(slika: galleryItems[index], index: index),
        ));
  }

  Widget buildCard({required Slika slika, required int index}) {
    return Container(
        width: 100,
        height: 140,
        padding: EdgeInsets.zero,
        child: Column(children: [
          Expanded(
              child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            /*child: Image.network(
              slika.slika!,
              fit: BoxFit.cover,
            ),*/
            child: Image.memory(base64Decode(slika.slika!), fit: BoxFit.cover),
          )),
          IconButton(
              icon: const Icon(
                Icons.clear,
              ),
              iconSize: 15,
              splashRadius: 15,
              color: Colors.grey,
              onPressed: () {
                deleteImage(index, slika.slikaId);
              })
        ]));
  }

  File? _image;
  String? _base64Image;

  File? _galleryImage;
  String? _galleryBase64Image;

  /*Future getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      _image = File(result.files.single.path!);
      _base64Image = base64Encode(_image!.readAsBytesSync());
      setState(() {
        _naslovna =
            _image != null ? Image.file(_image!, fit: BoxFit.cover) : _naslovna;
      });
    }
  }*/

  Future getImage(Function(ImageObj) onImageSelected) async {
    File? file;
    String? base64Image;
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      file = File(result.files.single.path!);
      base64Image = base64Encode(file!.readAsBytesSync());
      final image = Image.file(
        file,
        fit: BoxFit.cover,
      );
      print("image: ${image}");
      print("baase64: $base64Image");
      onImageSelected(ImageObj(image, base64Image));
    }
  }

  /*Future getProgramSlika() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      _image = File(result.files.single.path!);
      _base64Image = base64Encode(_image!.readAsBytesSync());
      setState(() {
        _programSlika = _image != null
            ? Image.file(_image!, fit: BoxFit.cover)
            : _programSlika;
      });
    }
  }*/

  Future addImageGallery() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      _galleryImage = File(result.files.single.path!);
      _galleryBase64Image = base64Encode(_galleryImage!.readAsBytesSync());
      setState(() {
        galleryItems.add(Slika(null, _galleryBase64Image));
      });
    }
  }
}
