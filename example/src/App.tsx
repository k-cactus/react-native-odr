import * as React from 'react';

import { StyleSheet, View, Text } from 'react-native';
import Odr, { download, OdrOptions } from 'react-native-odr';

export default function App() {
  const [result, setResult] = React.useState<string>();
  const [error, setError] = React.useState<Error>();

  React.useEffect(() => {
    const options: OdrOptions = {
      packageName: 'TestPackageName',
      packageType: 'md', // extension
    };
    Odr.progress((res) => {
      console.log('progress', res);
    });
    Odr.finished((res) => {
      console.log('finished', res);
    });
    download(options)
      .then((filePath) => {
        setResult(filePath.toString());
      })
      .catch(setError);
  }, []);

  return (
    <View style={styles.container}>
      <Text>FilePath: {result}</Text>
      <Text>OdrError: {(error && error.message) || ''}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
