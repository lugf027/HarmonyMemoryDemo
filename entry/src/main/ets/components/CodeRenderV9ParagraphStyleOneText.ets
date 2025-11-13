import pasteboard from '@ohos.pasteboard';
import promptAction from '@ohos.promptAction';
import { BusinessError } from '@kit.BasicServicesKit';
import { CodeTheme } from './utils/codeTheme';
import { highlightCodeToJSON } from './utils/highlightCode';
import { defaultCodeHighlight } from './utils/CodeHighlight';
import { LengthMetrics } from '@kit.ArkUI';

const copyContent = async (text: string) => {
  let pasteData = pasteboard.createPlainTextData(text);
  let systemPasteboard = pasteboard.getSystemPasteboard();
  await systemPasteboard.setData(pasteData).then((data) => {
    promptAction.showToast({
      message: '复制成功'
    });
  }).catch((err: BusinessError) => {
    // 此处不知道是不是真机有bug实际是复制成功了，模拟器中复制进入then
    promptAction.showToast({
      message: '复制失败' + err.message
    });
  });
};


@ComponentV2
export struct CodeRenderV9ParagraphStyleOneText {
  @Require @Param text: string = '';
  @Param codeTheme: CodeTheme = CodeTheme.Dark;
  @Local controller: TextController = new TextController();
  @Local styledWhole: MutableStyledString = new MutableStyledString('');

  aboutToAppear(): void {
    this.reparse();
  }

  @Monitor('text')
  onTextChange(): void {
    this.reparse();
  }

  @Monitor('codeTheme')
  onThemeChange(): void {
    this.reparse();
  }

  reparse(): void {
    if (this.text.length === 0) {
      this.styledWhole = new MutableStyledString('');
      return;
    }
    const nodes = highlightCodeToJSON(this.text, defaultCodeHighlight,) as HighlightNode[];
    let fullText: string = '';
    let offset: number = 0;
    const styles: Array<StyleOptions> = [];
    for (let r = 0; r < nodes.length; r++) {
      const row = nodes[r];
      for (let i = 0; i < row.code.length; i++) {
        const seg = row.code[i];
        const len = seg.text.length;
        fullText += seg.text;
        styles.push({
          start: offset,
          length: len,
          styledKey: StyledStringKey.FONT,
          styledValue: new TextStyle({ fontColor: seg.color, fontSize: LengthMetrics.vp(14.8) })
        });
        offset += len;
      }
      if (r < nodes.length - 1) {
        fullText += '\n';
        offset += 1;
      }
    }
    if (fullText.length > 0) {
      styles.push({ start: 0, length: fullText.length, styledKey: StyledStringKey.LINE_HEIGHT, styledValue: new LineHeightStyle(LengthMetrics.vp(22)) });
    }
    this.styledWhole = new MutableStyledString(fullText, styles);
    this.controller.setStyledString(this.styledWhole);
  }

  build() {
    Stack({
      alignContent: Alignment.TopEnd
    }) {
      Column() {
        if (this.codeTheme === CodeTheme.Dark) {
          Image($rawfile('imgs/copy_w1.png')).width(18).height(18)
            .interpolation(ImageInterpolation.Medium);
        } else {
          Image($rawfile('imgs/copy_g1.png')).width(18).height(18)
            .interpolation(ImageInterpolation.Medium);
        }
      }
      .margin({
        top: 10, right: 10
      })
      .padding({
        top: 4,
        bottom: 4,
        left: 8,
        right: 8
      })
      .borderRadius(6)
      .backgroundColor(this.codeTheme === CodeTheme.Dark ? 'rgba(0,0,0,0.7)' : 'rgba(0, 0, 0, 0.03)')
      .zIndex(2)
      .onClick(() => {
        copyContent(this.text);
      });

      Row() {

        Scroll() {
          Column() {
            Text(undefined, { controller: this.controller })
              .onAppear(() => {
                this.controller.setStyledString(this.styledWhole);
              });
          }
          .alignItems(HorizontalAlign.Start)
          .padding({
            left: 12,
            right: 12,
            bottom: 12
          });
        }
        .width('100%')
        .align(Alignment.Start)
        .scrollable(ScrollDirection.Horizontal)
        .edgeEffect(EdgeEffect.Spring);
      }
      .backgroundColor(this.codeTheme === CodeTheme.Dark ? '#282C35' : '#FAFAFA')
      .borderRadius(6);
    }.width('100%');
  }
}

export interface HighlightNode {
  type: 'row',
  code: HighlightCode[]
}

export interface HighlightCode {
  color: string;
  text: string;
  type: string;
}