import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-odr' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({
    ios: "- You have run 'pod install'\n",
    default: '- Platform is supported\n',
  }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

const Odr = NativeModules.Odr
  ? NativeModules.Odr
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export type OdrOptions = {
  packageName: string;
  packageType: string;
};

export function download(options: OdrOptions): Promise<string | Error> {
  return Odr.download(options);
}
