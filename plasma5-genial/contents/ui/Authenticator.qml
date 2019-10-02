/*
Copyright (C) 2019 Nathan P. Bombana

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/.
*/

import QtQuick 2.0
import QtWebKit 3.0
import QtQuick.Window 2.13
import QtWebKit.experimental 1.0

/*
 * Window used to authenticate the users with Genius oAuth.
 *
 * The window will close if some error occur during the page loading or the user deny the request.
 */
Window {
    id: root
    width: 800
    height: 600

    WebView {
        id: authenticator

        width: root.width
        height: root.height

        onUrlChanged: {
            let match = url.toString().match('https:\/\/genius\.com\/#access_token=(.+(?=&))');
            if(match) {
                root.success(match[1]);
            } else if(url.toString().startsWith("https://genius.com/#error=access_denied")) {
                root.failed();
            }
        }

        experimental.userAgent:"Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36  (KHTML, like Gecko) Chrome/32.0.1667.0 Safari/537.36"
    
        onLoadingChanged: {
            if(loadRequest.errorCode !== 200 && loadRequest.errorCode !== 0) {
                root.failed();
            }
        }
    }

    /*
     * Sent when the token is successfully acquired.
     *
     * @param token string  The obtained token.
     */
    signal success(string token)

    /*
     * Sent when something goes wrong in the authentication process.
     */
    signal failed()

    onSuccess: close();

    onFailed: close();

    /*
     * Function used to start the authentication process.
     *
     * It will redirect the webview to the oAuth request URL and show the window.
     * Every time this method is called, the location of the webview resets to the initial state (token request page).
     */
    function authenticate() {
        authenticator.url = "https://api.genius.com/oauth/authorize?client_id=PyYhlOZ-ALLjy10Bd2zwwMzO4buASkM2aarcsiBZyPTbJ5iXVHqTs_vmo1mhFA4D&redirect_uri=https://genius.com/&response_type=token";
        show();
    }
}
