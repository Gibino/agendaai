import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/constants/api_constants.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../data/models/promotion_model.dart';
import '../../../shared/widgets/shimmer_list.dart';
import '../../../core/theme/app_theme.dart';

part 'tela_promocoes.g.dart';

@riverpod
Future<List<PromotionModel>> promocoesAtivas(PromocoesAtivasRef ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get(ApiConstants.promocoes);
  final list = response.data['dados'] as List;
  return list.map((e) => PromotionModel.fromJson(e as Map<String, dynamic>)).toList();
}

class TelaPromocoes extends ConsumerWidget {
  const TelaPromocoes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promocoesAsync = ref.watch(promocoesAtivasProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Promoções')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(promocoesAtivasProvider),
        child: promocoesAsync.when(
          data: (promos) => promos.isEmpty
              ? ListView(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.local_offer_rounded,
                              size: 72, color: AppColors.primary),
                          const SizedBox(height: 16),
                          Text('Nenhuma promoção ativa no momento',
                              style: AppTextStyles.heading, textAlign: TextAlign.center),
                          const SizedBox(height: 8),
                          Text(
                            'Volte em breve para conferir as novidades!',
                            style: AppTextStyles.body.copyWith(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: promos.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => _CardPromocao(promocao: promos[i]),
                ),
          loading: () => ShimmerVerticalList(count: 4),
          error: (_, __) =>
              const Center(child: Text('Erro ao carregar promoções')),
        ),
      ),
    );
  }
}

class _CardPromocao extends StatelessWidget {
  final PromotionModel promocao;

  const _CardPromocao({required this.promocao});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final empresa = promocao.company;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge de destaque
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.12),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_offer_rounded,
                    size: 16, color: AppColors.accent),
                const SizedBox(width: 6),
                Text(
                  'Promoção',
                  style: AppTextStyles.caption.copyWith(
                      color: AppColors.accent, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Text(
                  'Até ${_formatDate(promocao.endsAt)}',
                  style: AppTextStyles.caption.copyWith(color: AppColors.accent),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(promocao.title, style: AppTextStyles.heading),
                if (promocao.description != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    promocao.description!,
                    style: AppTextStyles.body.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (empresa != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.store_rounded,
                          size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        empresa['name'] as String? ?? '',
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
