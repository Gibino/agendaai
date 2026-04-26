import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../data/models/banner_model.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/company_model.dart';
import '../widgets/carrossel_banner.dart';
import '../widgets/categorias_rapidas.dart';
import '../widgets/card_empresa.dart';
import '../../../shared/widgets/shimmer_list.dart';
import '../../../core/theme/app_theme.dart';

part 'tela_principal.g.dart';

// ── Providers de dados da Home ───────────────────────────────────────────────

@riverpod
Future<List<BannerModel>> bannersHome(BannersHomeRef ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get(ApiConstants.banners);
  final list = response.data['dados'] as List;
  return list.map((e) => BannerModel.fromJson(e as Map<String, dynamic>)).toList();
}

@riverpod
Future<List<CategoryModel>> categoriasHome(CategoriasHomeRef ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get(ApiConstants.categorias);
  final list = response.data['dados'] as List;
  return list.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
}

@riverpod
Future<List<CompanyModel>> empresasDestaque(EmpresasDestaqueRef ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get(ApiConstants.empresas, queryParameters: {'take': 10});
  final list = response.data['dados']['companies'] as List;
  return list.map((e) => CompanyModel.fromJson(e as Map<String, dynamic>)).toList();
}

// ── Tela Principal ───────────────────────────────────────────────────────────

class TelaPrincipal extends ConsumerWidget {
  const TelaPrincipal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(authStateProvider).valueOrNull;
    final bannersAsync = ref.watch(bannersHomeProvider);
    final categoriasAsync = ref.watch(categoriasHomeProvider);
    final empresasAsync = ref.watch(empresasDestaqueProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(bannersHomeProvider);
          ref.invalidate(categoriasHomeProvider);
          ref.invalidate(empresasDestaqueProvider);
        },
        child: CustomScrollView(
          slivers: [
            // App Bar com saudação
            SliverAppBar(
              floating: true,
              snap: true,
              titleSpacing: 24,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    usuario?.name != null
                        ? 'Olá, ${usuario!.name!.split(' ').first} 👋'
                        : 'Olá! 👋',
                    style: AppTextStyles.heading,
                  ),
                  Text(
                    'O que você procura hoje?',
                    style: AppTextStyles.caption.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: SearchBar(
                  hintText: 'Buscar serviços, empresas...',
                  leading: const Icon(Icons.search_rounded),
                  elevation: WidgetStateProperty.all(0),
                  backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).inputDecorationTheme.fillColor,
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),

            // Carrossel de banners
            SliverToBoxAdapter(
              child: bannersAsync.when(
                data: (banners) => banners.isEmpty
                    ? const SizedBox.shrink()
                    : CarrosselBanner(banners: banners),
                loading: () => const _BannerShimmer(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),

            // Seção: Categorias
            const SliverToBoxAdapter(child: _SectionTitle(title: 'Categorias')),
            SliverToBoxAdapter(
              child: categoriasAsync.when(
                data: (cats) => CategoriasRapidas(categorias: cats),
                loading: () => const ShimmerHorizontalList(itemWidth: 80, height: 88),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),

            // Seção: Empresas em destaque
            const SliverToBoxAdapter(
              child: _SectionTitle(title: 'Empresas em Destaque'),
            ),
            empresasAsync.when(
              data: (empresas) => SliverList.separated(
                itemCount: empresas.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CardEmpresa(empresa: empresas[i]),
                ),
              ),
              loading: () => SliverToBoxAdapter(
                child: ShimmerVerticalList(count: 5),
              ),
              error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
        child: Text(title, style: AppTextStyles.heading),
      );
}

class _BannerShimmer extends StatelessWidget {
  const _BannerShimmer();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: ShimmerBox(height: 180, borderRadius: 16),
      );
}
