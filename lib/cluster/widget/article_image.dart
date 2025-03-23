import 'package:flutter/material.dart';
import 'package:kite_api_client/kite_api_client.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleImage extends StatelessWidget {
  const ArticleImage(this.article, {super.key});

  final Article article;

  Future<void> _launchUrl() async {
    await launchUrl(Uri.parse(article.link));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _launchUrl,
          child: Stack(
            children: [
              Image.network(
                article.image!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Container(
                    width: double.infinity,
                    height: 200,
                    color: Theme.of(context).colorScheme.surface,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(
                        Icons.error,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),

              // Domain overlay
              Positioned(
                bottom: 4,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(179),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    article.domain,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (article.imageCaption != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              article.imageCaption!,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(fontStyle: FontStyle.italic),
            ),
          ),
      ],
    );
  }
}
