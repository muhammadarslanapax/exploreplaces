import '../utils/Common.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/context_extensions.dart';
import '../utils/Extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../utils/Extensions/Colors.dart';
import '../utils/Extensions/Constants.dart';
import 'VimeoEmbedWidget.dart';
import 'YouTubeEmbedWidget.dart';

class HtmlWidget extends StatelessWidget {
  final String? postContent;
  final Color? color;

  HtmlWidget({this.postContent, this.color});

  @override
  Widget build(BuildContext context) {
    return Html(
      data: postContent!,
      onLinkTap: (s, _, __, ___) {
        mLaunchUrl(s!, forceWebView: true);
      },
      onImageTap: (s, _, __, ___) {
        //openPhotoViewer(context, Image.network(s).image);
      },
      style: {
        'embed': Style(color: color ?? transparentColor, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, fontSize: FontSize(16)),
        'strong': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'a': Style(color: color ?? Colors.blue, fontWeight: FontWeight.bold, fontSize: FontSize(16)),
        'div': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'figure': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16), padding: EdgeInsets.zero, margin: EdgeInsets.zero),
        'h1': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'h2': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'h3': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'h4': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'h5': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'h6': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'ol': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'ul': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'li': Style(
          color: color ?? textPrimaryColorGlobal,
          fontSize: FontSize(16),
          listStyleType: ListStyleType.DISC,
          listStylePosition: ListStylePosition.OUTSIDE,
          lineHeight: LineHeight(1.2),
        ),
        'strike': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'u': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'b': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'i': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'hr': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'header': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'code': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'data': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'body': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'big': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'blockquote': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'audio': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'img': Style(width: context.width(), padding: EdgeInsets.only(bottom: 8), fontSize: FontSize(16)),
      },
      customRender: {
        "img": (RenderContext renderContext, Widget child) {
           return cachedImage(renderContext.parser.htmlData.text.splitBetween('src="', '"')).onTap(() {
            //
          });
        },
        "youtube": (RenderContext renderContext, Widget child) {
           return YouTubeEmbedWidget(renderContext.parser.htmlData.text.splitBetween('<youtube>', '</youtube').convertYouTubeUrlToId());
        },
        "vimeo": (RenderContext renderContext, Widget child) {
            return VimeoEmbedWidget(renderContext.parser.htmlData.text.splitBetween('<vimeo>', '</vimeo'));
        },
        "figure": (RenderContext renderContext, Widget child) {
          if (renderContext.tree.element!.innerHtml.contains('yout')) {
            return YouTubeEmbedWidget(renderContext.tree.element!.innerHtml.splitBetween('<div class="wp-block-embed__wrapper">', "</div>").replaceAll('<br>', '').convertYouTubeUrlToId());
          } else if (renderContext.tree.element!.innerHtml.contains('vimeo')) {
            return VimeoEmbedWidget(renderContext.tree.element!.innerHtml.splitBetween('<div class="wp-block-embed__wrapper">', "</div>").replaceAll('<br>', '').splitAfter('com/'));
          } else if (renderContext.tree.element!.innerHtml.contains('audio controls')) {
            return Theme(
              data: ThemeData(),
              child: child,
            );
          } else {
            return child;
          }
        },
      },
    );
  }
}
