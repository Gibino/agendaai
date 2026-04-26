import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/constants/api_constants.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../data/models/company_model.dart';
import '../../../features/home/widgets/card_empresa.dart';
import '../../../shared/widgets/shimmer_list.dart';
import '../../../core/theme/app_theme.dart';
import 'tela_categorias.dart';

part 'tela_detalhe_categoria.g.dart';

@riverpod
Future<List<CompanyModel>> empresasPorCategoria(
  EmpresasPorCategoriaRef ref,
  String categoriaId,
) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get(
    ApiConstants.empresas,
    queryParameters: {'categoryId': categoriaId},
  );
  final list = response.data['dados']['companies'] as List;
  return list.map((e) => CompanyModel.fromJson(e as Map<String, dynamic>)).toList();
}

class TelaDetalheCategoria extends ConsumerWidget {
  final String categoriaId;

  const TelaDetalheCategoria({super.key, required this.categoriaId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriasAsync = ref.watch(todasCategoriasProvider);
    final empresasAsync = ref.watch(empresasPorCategoriaProvider(categoriaId));

    final nomeCategoria = categoriasAsync.valueOrNull
            ?.firstWhere(
              (c) => c.id == categoriaId,
              orElse: () => const CategoryModel(
                  id: '', name: 'Categoria', slug: ''),
            )
            .name ??
        'Categoria';

    return Scaffold(
      appBar: AppBar(title: Text(nomeCategoria)),
      body: empresasAsync.when(
        data: (empresas) => empresas.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.store_rounded,
                        size: 64, color: AppColors.primary),
                    const SizedBox(height: 16),
                    Text('Nenhuma empresa nesta categoria',
                        style: AppTextStyles.body),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: empresas.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => CardEmpresa(empresa: empresas[i]),
              ),
        loading: () => ShimmerVerticalList(count: 5),
        error: (_, __) =>
            const Center(child: Text('Erro ao carregar empresas')),
      ),
    );
  }
}
