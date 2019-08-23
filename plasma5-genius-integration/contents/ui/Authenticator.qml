import QtQuick 2.0
import QtWebKit 3.0
import QtWebKit.experimental 1.0
import QtQuick 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

import '../code/api-helper.js' as ApiHelper

PlasmaCore.Dialog {
    id: root

    mainItem: WebView {
        id: authenticator

        width: 800
        height: 600

        onUrlChanged: {
            let match = url.toString().match('https:\/\/genius\.com\/#access_token=(.+(?=&))');
            if(match) {
                root.success(match[1]);
            }
        }

        experimental.userAgent:"Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36  (KHTML, like Gecko) Chrome/32.0.1667.0 Safari/537.36"
        url: "https://api.genius.com/oauth/authorize?client_id=PyYhlOZ-ALLjy10Bd2zwwMzO4buASkM2aarcsiBZyPTbJ5iXVHqTs_vmo1mhFA4D&redirect_uri=https://genius.com/&response_type=token&scope=me%20create_annotation"
    }

    signal success(string token)
    signal failed()

    onSuccess: {
        visible = false;
    }

    function authenticate() {
        authenticator.url = "https://api.genius.com/oauth/authorize?client_id=PyYhlOZ-ALLjy10Bd2zwwMzO4buASkM2aarcsiBZyPTbJ5iXVHqTs_vmo1mhFA4D&redirect_uri=https://genius.com/&response_type=token&scope=me%20create_annotation";
        visible = true;
    }
}
