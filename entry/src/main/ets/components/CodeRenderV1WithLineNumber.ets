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
export struct CodeRenderV1WithLineNumber {
  @Require @Param text: string = '';
  @Param codeTheme: CodeTheme = CodeTheme.Dark;
  @Local rowLimit: number = -2;
  @Local idxWidth: number = 10;

  calcRow() {
    let len = this.text.split('\n').slice(1, -2).length;
    if (len >= 10) {
      this.idxWidth = 20;
    }
    if (len >= 100) {
      this.idxWidth = 30;
    }
    return len;
  }

  showMore() {
    this.rowLimit = -2;
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
              ForEach(this.calcRow() >= 10 ? this.text.split('\n').slice(1, this.rowLimit) :
                this.text.split('\n').slice(1, -2),
                (rowText: string, ri: number) => {
                  Stack({ alignContent: Alignment.Start }) {
                    // 索引
                    Row() {
                      Text(ri + 1 + '')
                        .width(this.idxWidth)
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                        .fontSize(13)
                        .fontColor(this.codeTheme === CodeTheme.Dark ? '#80f1f1f1' : '#6d666666')
                        .textAlign(TextAlign.End);

                      Row()
                        .margin({ left: 8, right: 8 })
                        .width(1)
                        .height(23)
                        .backgroundColor(this.codeTheme === CodeTheme.Dark ? '#51f1f1f1' : '#77888888');
                    };

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
                    .margin({ left: this.idxWidth + 16 });
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

        if (this.calcRow() >= 10 && this.rowLimit != -2) {
          Row() {
            Image($rawfile('imgs/down_b.png')).width(20).height(20);
          }
          .justifyContent(FlexAlign.Center)
          .width(60)
          .height(25)
          .borderRadius(99)
          .backgroundColor('#5cffffff')
          .margin({ bottom: 7 })
          .onClick(() => {
            this.showMore();
          });
        }
      };
    }.width('100%');
  }
}


