Option Explicit
Dim objSHL : Set objSHL = CreateObject("WScript.Shell")
Dim n,i,x

n=1 ' sss

Dim zz
zz = "RGV2YW50IGxhIHByb3BhZ2F0aW9uIGRlcyBpbmNlbmRpZXMgZW4gQW1hem9uaWUsIGxlIFNvbW1ldCBkdSBHNyBhIGNoYW5nw6kgc29uIGFnZW5kYSBwb3VyIOKAnGFmZnJvbnRlciBs4oCZdXJnZW5jZeKAnS4gTGVzIFNlcHQgLUZyYW5jZSwgQWxsZW1hZ25lLCBHcmFuZGUtQnJldGFnbmUsIEl0YWxpZSwgSmFwb24sIENhbmFkYSBldCDDiXRhdHMtVW5pcy0gb250IGpvdcOpLCBhdmVjIGzigJlVbmlvbiBFdXJvcMOpZW5uZSwgbGUgcsO0bGUgZGUgcG9tcGllcnMgcGxhbsOpdGFpcmVzLgpMZSBwcsOpc2lkZW50IE1hY3JvbiwgZW4gaGFiaXQgZGUgY2hlZiBwb21waWVyLCBhIGxhbmPDqSBs4oCZYWxhcm1lIDog4oCcbm90cmUgbWFpc29uIGVzdCBlbiBmbGFtbWVz4oCdLiBMZSBwcsOpc2lkZW50IFRydW1wIGEgcHJvbWlzIGxlIHBsdXMgZ3JhbmQgZW5nYWdlbWVudCDDqXRhc3VuaWVuIGRhbnMgbGUgdHJhdmFpbCBk4oCZZXh0aW5jdGlvbi4KTGVzIHByb2plY3RldXJzIG3DqWRpYXRpcXVlcyBzZSBjb25jZW50cmVudCBzdXIgbGVzIGluY2VuZGllcyBhdSBCcsOpc2lsLCBsYWlzc2FudCBkYW5zIGzigJlvbWJyZSB0b3V0IGxlIHJlc3RlLiBBdmFudCB0b3V0IGxlIGZhaXQgcXVlIGxhIGRlc3RydWN0aW9uIG5lIHRvdWNoZSBwYXMgc2V1bGVtZW50IGxhIGZvcsOqdCBhbWF6b25pZW5uZSAoYXV4IGRldXggdGllcnMgYnLDqXNpbGllbm5lKSwgcsOpZHVpdGUgZW4gMjAxMC0yMDE1IGRlIHByZXNxdWUgMTAgbWlsbGUga20yIHBhciBhbiwgbWFpcyBhdXNzaSBsZXMgZm9yw6p0cyB0cm9waWNhbGVzIGTigJlBZnJpcXVlIMOpcXVhdG9yaWFsZSBldCBk4oCZQXNpZSBzdWQtb3JpZW50YWxlLiBMZXMgZm9yw6p0cyB0cm9waWNhbGVzIG9udCBwZXJkdSwgZW4gbW95ZW5uZSBjaGFxdWUgYW5uw6llLCB1bmUgc3VwZXJmaWNpZSDDqXF1aXZhbGVudGUgw6AgY2VsbGUgdG90YWxpc2FudCBQacOpbW9udCwgTG9tYmFyZGllIGV0IFbDqW7DqXRpZS4="
For i = 1 To n
x= objSHL.Popup(zz,10,"title")
Next