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
    { title: 'CodeRender TextPage', url: 'pages/CodeRenderTextPage' },
    { title: 'CodeRenderV1 WithLineNumberPage', url: 'pages/CodeRenderV1WithLineNumberPage' },
    { title: 'CodeRenderV2 WithoutLineNumberPage', url: 'pages/CodeRenderV2WithoutLineNumberPage' },
    { title: 'CodeRenderV3 PreParseStylePage', url: 'pages/CodeRenderV3PreParseStylePage' },
    { title: 'CodeRenderV4 NoTracePage', url: 'pages/CodeRenderV4NoTracePage' },
    { title: 'CodeRenderV5 MergeNodePage', url: 'pages/CodeRenderV5MergeNodePage' },
    { title: 'CodeRenderV6 UICodePage', url: 'pages/CodeRenderV6UICodePage' },
    { title: 'CodeRenderV7 SwitchCodeStylePage', url: 'pages/CodeRenderV7SwitchCodeStylePage' },
    { title: 'CodeRenderV7.1 SwitchCodeStyleOneTextPage', url: 'pages/CodeRenderV71SwitchCodeStyleOneTextPage' },
    { title: 'CodeRenderV8 ParagraphStylePage', url: 'pages/CodeRenderV8ParagraphStylePage' },
    { title: 'CodeRenderV9 ParagraphStyleOneTextPage', url: 'pages/CodeRenderV9ParagraphStyleOneTextPage' },
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