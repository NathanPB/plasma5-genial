import '..'

AppRepresentation {

    property string term

    DescriptionText {
        text: `Nothing found about ${term} :(`

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
    }
}