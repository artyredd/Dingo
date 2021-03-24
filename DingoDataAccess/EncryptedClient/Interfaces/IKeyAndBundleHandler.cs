﻿using DingoAuthentication.Encryption;
using System.Threading.Tasks;

namespace DingoDataAccess
{
    public interface IKeyAndBundleHandler<TKeyBundleType> where TKeyBundleType : IKeyBundleModel, new()
    {
        Task<IKeyBundleModel> GetBundle(string Id, string FriendId);
        Task<(byte[] X509IdentityKey, byte[] IdentityPrivateKey)> GetKeys(string Id);
        Task<bool> RemoveBundle(string Id, string FriendId);
        Task<bool> SetBundle(string Id, string FriendId, TKeyBundleType bundle);
        Task<bool> SetKeys(string Id, byte[] X509IdentityKey, byte[] IdentityPrivateKey);
    }
}