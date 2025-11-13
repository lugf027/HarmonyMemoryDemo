import pasteboard from '@ohos.pasteboard';
import promptAction from '@ohos.promptAction';
import { BusinessError } from '@kit.BasicServicesKit';
import { codeStyle } from './utils/codeStyle';
import handleCodeLib from './utils/handleCodeLib';
import { CodeTheme } from './utils/codeTheme';

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

let reg = /(\.\w+\()/g;

@ComponentV2
export struct CodeRenderV5MergeNode {
  @Require @Param text: string = '';
  @Param codeTheme: CodeTheme = CodeTheme.Dark;
  @Local rowLimit: number = -2;
  @Local parsedRows: CodeSegment[][] = [];

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
    const rows: CodeSegment[][] = [];
    const isDark = this.codeTheme === CodeTheme.Dark;
    const lines = (this.text || '').split('\n');
    for (let i = 0; i < lines.length; i++) {
      const rowText = lines[i];
      const segs: CodeSegment[] = [];
      if (rowText.trim().slice(0, 2) == '//') {
        segs.push({ text: rowText, color: isDark ? '#80f1f1f1' : '#8b666666' });
      } else {
        const parts = rowText.split(/(\w+|\.\w+\()/g);
        for (let j = 0; j < parts.length; j++) {
          const item = parts[j];
          if (reg.test(item)) {
            const fnName = item.slice(0, -1);
            segs.push({ text: fnName, color: isDark ? '#4FC1FF' : '#ff108edd' });
            segs.push({ text: '(', color: codeStyle['('] });
          } else {
            const tokens = handleCodeLib(item);
            for (let k = 0; k < tokens.length; k++) {
              const tk = tokens[k];
              const color: string = codeStyle[tk] || (isDark ? '#ffd9d9d9' : '#ff676767');
              segs.push({ text: tk, color });
            }
          }
        }
      }
      rows.push(segs);
    }
    this.parsedRows = rows;
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

      // 不可滚动了
      Stack({ alignContent: Alignment.Bottom }) {
        List() {
          ListItem() {
            Column() {
              ForEach(this.parsedRows,
                (row: CodeSegment[], ri: number) => {
                  Stack({ alignContent: Alignment.Start }) {
                    Row() {
                      Text() {
                        ForEach(row, (seg: CodeSegment) => {
                          Span(seg.text)
                            .fontColor(seg.color)
                            .fontSize(14);
                        });
                      };
                    }
                    .margin({ left: 16 });
                  }
                  .constraintSize({ minWidth: '100%' })
                  .height(23);
                });
            }
            .alignItems(HorizontalAlign.Start);
          }.padding({
            top: 15,
            bottom: 15,
            left: 10,
            right: 10
          });
        }
        .width('100%')
        .listDirection(Axis.Horizontal)
        .backgroundColor(this.codeTheme === CodeTheme.Dark ? '#282C35' : '#FAFAFA')
        .borderRadius(6)
        .scrollBar(BarState.Off);
      };
    }.width('100%');
  }
}

interface CodeSegment {
  text: string;
  color: string;
}
