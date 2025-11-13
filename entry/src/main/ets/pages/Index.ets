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
    { title: 'CodeRenderV2WithoutLineNumberPage', url: 'pages/CodeRenderV2WithoutLineNumberPage' },
    { title: 'CodeRenderV3PreParseStylePage', url: 'pages/CodeRenderV3PreParseStylePage' },
    { title: 'CodeRenderV4NoTracePage', url: 'pages/CodeRenderV4NoTracePage' },
    { title: 'CodeRenderV5MergeNodePage', url: 'pages/CodeRenderV5MergeNodePage' },
    { title: 'CodeRenderV6UICodePage', url: 'pages/CodeRenderV6UICodePage' },
    { title: 'CodeRenderV7SwitchCodeStylePage', url: 'pages/CodeRenderV7SwitchCodeStylePage' },
    { title: 'CodeRenderV8ParagraphStylePage', url: 'pages/CodeRenderV8ParagraphStylePage' },
    { title: 'CodeRenderV9ParagraphStyleOneTextPage', url: 'pages/CodeRenderV9ParagraphStyleOneTextPage' },
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