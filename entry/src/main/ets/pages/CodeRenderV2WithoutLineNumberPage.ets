import { CodeRenderV2WithoutLineNumber } from '../components/CodeRenderV2WithoutLineNumber';
import { buffer } from '@kit.ArkTS';
import { promptAction } from '@kit.ArkUI';

@Entry
@ComponentV2
struct CodeRenderV2WithoutLineNumberPage {
  @Local rawfilePath: string = 'StudentGradeManager.java';
  @Local rawfileContent: string = '';

  build() {
    Column() {
      Scroll() {
        Column() {
          CodeRenderV2WithoutLineNumber({
            text: this.rawfileContent
          });
        };
      };
    };
  }


  aboutToAppear(): void {
    this.loadRawfile();
  }

  loadRawfile() {
    try {
      let uint8Array: Uint8Array | undefined =
        this.getUIContext().getHostContext()?.resourceManager.getRawFileContentSync(this.rawfilePath);
      if (!uint8Array) {
        promptAction.showToast({
          message: '读取失败'
        });
        return;
      }
      let bf = buffer.from(uint8Array).buffer;
      let bf2 = new buffer.Blob([bf]);
      let pro = bf2.text();
      pro.then((str: string) => {
        this.rawfileContent = str;
      });

    } catch (error) {
      promptAction.showToast({
        message: '读取错误'
      });
    }
  }
}