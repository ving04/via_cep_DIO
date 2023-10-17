import 'package:flutter/material.dart';
import 'package:via_cep/models/back4app_model.dart';
import 'package:via_cep/models/maskFormatter.dart';
import 'package:via_cep/models/via_cep_model.dart';

import 'package:via_cep/repositories/back4app_repository.dart';
import 'package:via_cep/repositories/via_cep_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Back4appRepository b4aRepository;

  var cepController = TextEditingController(text: '');

  var viaCepRepository = ViaCepRepository();
  var viaCepModel = ViaCepModel();

  var b4aModel = Back4appModel();


  @override
  void initState() {
    b4aRepository = Back4appRepository();
    loadDbList();
    super.initState();
  }

  loadDbList() async {
    b4aModel = await b4aRepository.getDbCep();
    setState(() {});
  }

  @override
  void dispose() {
    cepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 55, 34, 124),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                title: const Text(
                  'Consultar CEP',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                content: SizedBox(
                  height: 180,
                  child: Column(
                    children: [
                      TextFormField(
                        inputFormatters: [maskFormatter],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'CEP',
                        ),
                        maxLength: 9,
                        keyboardType: TextInputType.number,
                        controller: cepController,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            var cep = cepController.text;
                            viaCepModel = await viaCepRepository.getCep(cep);
                            var logradouro = viaCepModel.logradouro!;
                            var localidade = viaCepModel.localidade!;
                            var uf = viaCepModel.uf!;
                            if (!mounted) return;
                            Navigator.pop(_);
                            cepController.text = '';

                            //TODO verificar se já existe no DB
                            var address = AddressModel(cep: cep, logradouro: logradouro, localidade: localidade, uf: uf);
                            var response = await b4aRepository.addCep(address);
                            if (response == null) return;
                            debugPrint('success on save to DB');
                            loadDbList();
                            setState(() {});
                          },
                          child: const Text('Buscar'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Lista de CEP',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: b4aModel.results == null
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: b4aModel.results?.length,
                        itemBuilder: (context, index) {
                          var addressList = b4aModel.results?[index];
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                            child: SizedBox(
                              height: 80,
                              child: Dismissible(
                                key: UniqueKey(),
                                onDismissed: (direction) async {
                                  await b4aRepository.deleteById(
                                      addressList.objectId.toString());
                                  loadDbList();
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(addressList!.logradouro),
                                      Text(addressList.localidade +' - '+ addressList.uf),
                                      Text('CEP: ' + addressList.cep),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
