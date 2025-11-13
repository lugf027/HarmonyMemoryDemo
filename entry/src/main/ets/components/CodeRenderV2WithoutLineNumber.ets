import pasteboard from '@ohos.pasteboard';
import promptAction from '@ohos.promptAction';
import { BusinessError } from '@kit.BasicServicesKit';
import { codeStyle } from '../utils/codeStyle';
import handleCodeLib from '../utils/handleCodeLib';
import { CodeTheme } from '../utils/codeTheme';

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

/**
 * 组件内存占用（Retained Size）		5750 KB
 * 其中 updateFuncByElmtId	4470 KB
 *       __id_refs__	1090 KB
 *       __use_refs__	192.48 KB
 * 其中 updateFuncByElemId 有 7760 个引用；__id_refs__ 有 22644 个未知引用； __use_refs__ 有 15556 个 codeTheme 的引用
 */
@ComponentV2
export struct CodeRenderV2WithoutLineNumber {
  @Require @Param text: string = '';
  @Param codeTheme: CodeTheme = CodeTheme.Dark;

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

        // Text('复制').fontColor(this.theme === CodeTheme.Dark ? "#fff" : "rgba(84, 84, 84, 0.70)").fontSize(13)
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
              // 分行
              ForEach(this.text.split('\n'),
                (rowText: string, ri: number) => {
                  Stack({ alignContent: Alignment.Start }) {
                    Row() {
                      Text() {
                        // 按行处理样式
                        if (rowText.trim().slice(0, 2) == '//') {
                          Span(rowText)
                            .fontColor(this.codeTheme === CodeTheme.Dark ? '#80f1f1f1' : '#8b666666')
                            .fontSize(14);
                        } else {
                          ForEach(rowText.split(/(\w+|\.\w+\()/g), (item: string) => {
                            if (reg.test(item)) {
                              Span(item.slice(0, -1))
                                .fontColor(this.codeTheme === CodeTheme.Dark ? '#4FC1FF' : '#ff108edd')
                                .fontSize(14);
                              Span('(')
                                .fontColor(codeStyle['('])
                                .fontSize(14);
                            } else {
                              // Text(item)
                              ForEach(handleCodeLib(item), (item: string) => {
                                Span(item)
                                  .fontColor(codeStyle[item] ||
                                    (this.codeTheme === CodeTheme.Dark ? '#ffd9d9d9' : '#ff676767'))
                                  .fontSize(14);
                              });
                            }
                          });
                        }
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


