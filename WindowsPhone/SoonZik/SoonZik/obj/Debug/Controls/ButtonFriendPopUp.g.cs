﻿

#pragma checksum "C:\Users\Gery\Documents\GitHub\Soonzik\WindowsPhone\SoonZik\SoonZik\Controls\ButtonFriendPopUp.xaml" "{406ea660-64cf-4c82-b6f0-42d48172a799}" "0650AD8AFD7AC95A03E8A6C8AECC6F0A"
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace SoonZik.Controls
{
    partial class ButtonFriendPopUp : global::Windows.UI.Xaml.Controls.UserControl, global::Windows.UI.Xaml.Markup.IComponentConnector
    {
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
 
        public void Connect(int connectionId, object target)
        {
            switch(connectionId)
            {
            case 1:
                #line 18 "..\..\Controls\ButtonFriendPopUp.xaml"
                ((global::Windows.UI.Xaml.Controls.Primitives.ButtonBase)(target)).Click += this.SendMessage;
                 #line default
                 #line hidden
                break;
            case 2:
                #line 19 "..\..\Controls\ButtonFriendPopUp.xaml"
                ((global::Windows.UI.Xaml.Controls.Primitives.ButtonBase)(target)).Click += this.GoToProfil;
                 #line default
                 #line hidden
                break;
            case 3:
                #line 20 "..\..\Controls\ButtonFriendPopUp.xaml"
                ((global::Windows.UI.Xaml.Controls.Primitives.ButtonBase)(target)).Click += this.DeleteContact;
                 #line default
                 #line hidden
                break;
            }
            this._contentLoaded = true;
        }
    }
}


