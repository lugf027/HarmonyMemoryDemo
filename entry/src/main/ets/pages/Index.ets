import { promptAction } from '@kit.ArkUI';
import router from '@ohos.router';

interface PageInfo {
  title: string;
  url: string;
  implemented?: boolean;
}

@Entry
@ComponentV2
struct Index {
  @Local pages: PageInfo[] = [
    { title: 'CodeRenderV1WithLineNumberPage', url: 'pages/CodeRenderV1WithLineNumberPage' },
    { title: 'CodeRenderV2WithoutLineNumberPage', url: 'pages/CodeRenderV2WithoutLineNumberPage', implemented: false }
  ];

  build() {
    Column() {
      List() {
        ForEach(this.pages, (item: PageInfo) => {
          ListItem() {
            Row() {
              Text(item.title)
                .fontSize(18)
                .fontColor(item.implemented === false ? '#888888' : '#000000');
            }
            .justifyContent(FlexAlign.Start)
            .height(50)
            .width('100%')
            .onClick(() => {
              if (item.implemented === false) {
                promptAction.showToast({ message: '页面暂未实现' });
                return;
              }
              router.pushUrl({ url: item.url });
            });
          }
          .margin({ left: 16, right: 16 });
        });
      }
      .width('100%');
    }
    .width('100%')
    .padding({ top: 20 });
  }
}