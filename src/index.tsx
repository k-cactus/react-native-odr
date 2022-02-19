import { NativeModules, NativeAppEventEmitter, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-odr' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({
    ios: "- You have run 'pod install'\n",
    default: '- Platform is supported\n',
  }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

if (!NativeModules.Odr) {
  throw new Error(LINKING_ERROR);
}

export type OdrOptions = {
  packageName: string;
  packageType: string;
};

export type OdrProgressType = {
  completedUnitCount: number;
  fractionCompleted: number;
  totalUnitCount: number;
};

export type OdrFinishedType = {
  success: boolean;
  error?: Error;
};

const Odr = {
  download: (opt: OdrOptions): Promise<string | Error> => {
    return NativeModules.Odr.download(opt);
  },
  progress: (onProgress: (data: OdrProgressType) => void): void => {
    NativeAppEventEmitter.addListener(
      'downloadProgress',
      (data: OdrProgressType) => {
        if (onProgress) {
          onProgress(data);
        }
      }
    );
  },
  finished: (onFinished: (data: OdrFinishedType) => void): void => {
    NativeAppEventEmitter.addListener(
      'downloadFinished',
      (data: OdrFinishedType) => {
        if (onFinished) {
          onFinished(data);
        }
      }
    );
  },
};

export function download(options: OdrOptions): Promise<string | Error> {
  return Odr.download(options);
}

export default Odr;
