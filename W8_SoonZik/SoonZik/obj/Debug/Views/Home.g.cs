﻿

#pragma checksum "C:\Users\Julien\Documents\Visual Studio 2013\Projects\SoonZik - Copie\SoonZik\Views\Home.xaml" "{406ea660-64cf-4c82-b6f0-42d48172a799}" "025B369C4BEBB0524A0E64448A41DF94"
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace SoonZik
{
    partial class Home : global::Windows.UI.Xaml.Controls.Page, global::Windows.UI.Xaml.Markup.IComponentConnector
    {
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
 
        public void Connect(int connectionId, object target)
        {
            switch(connectionId)
            {
            case 1:
                #line 67 "..\..\Views\Home.xaml"
                ((global::Windows.UI.Xaml.Controls.Primitives.ButtonBase)(target)).Click += this.news_btn_Click;
                 #line default
                 #line hidden
                break;
            case 2:
                #line 68 "..\..\Views\Home.xaml"
                ((global::Windows.UI.Xaml.Controls.Primitives.ButtonBase)(target)).Click += this.shop_btn_Click;
                 #line default
                 #line hidden
                break;
            case 3:
                #line 69 "..\..\Views\Home.xaml"
                ((global::Windows.UI.Xaml.Controls.Primitives.ButtonBase)(target)).Click += this.community_btn_Click;
                 #line default
                 #line hidden
                break;
            case 4:
                #line 70 "..\..\Views\Home.xaml"
                ((global::Windows.UI.Xaml.Controls.Primitives.ButtonBase)(target)).Click += this.audio_player_btn_Click;
                 #line default
                 #line hidden
                break;
            }
            this._contentLoaded = true;
        }
    }
}


