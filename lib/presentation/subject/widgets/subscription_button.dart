import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/subject_subscription_provider.dart';

class SubscriptionButton extends ConsumerStatefulWidget {
  final String subjectId;
  final bool initialSubscriptionStatus;
  final VoidCallback? onSubscriptionChanged;

  const SubscriptionButton({
    super.key,
    required this.subjectId,
    this.initialSubscriptionStatus = false,
    this.onSubscriptionChanged,
  });

  @override
  ConsumerState<SubscriptionButton> createState() => _SubscriptionButtonState();
}

class _SubscriptionButtonState extends ConsumerState<SubscriptionButton> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(subjectSubscriptionProvider.notifier).checkSubscriptionStatus(widget.subjectId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionState = ref.watch(subjectSubscriptionProvider);
    final subscriptionNotifier = ref.read(subjectSubscriptionProvider.notifier);

    final isSubscribed = subscriptionNotifier.isSubscribed(widget.subjectId);
    final isLoading = subscriptionState.isLoading;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isLoading
            ? null
            : () async {
                if (isSubscribed) {
                  await subscriptionNotifier.unsubscribeFromSubject(widget.subjectId);
                } else {
                  await subscriptionNotifier.subscribeToSubject(widget.subjectId);
                }
                widget.onSubscriptionChanged?.call();
              },
        icon: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Icon(
                isSubscribed ? Icons.check : Icons.add,
                size: 20,
              ),
        label: Text(
          isSubscribed ? 'Subscribed' : 'Subscribe',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSubscribed ? Colors.green : Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}